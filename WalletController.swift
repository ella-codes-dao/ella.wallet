//
//  WalletController.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/22/23.
//

import Foundation
import MnemonicSwift
import CryptoSwift
import CryptoKeychain
import CryptoKit
import UIKit
import RealHTTP
import Flow
import Combine
import RealmSwift
import IceCream

//import WalletConnectNetworking
//import Web3Wallet

class WalletController: ObservableObject {
    @Published var selectedDAPP: selectedDAPP = .none
    @Published var showSettingsMenu = false
    @Published var flowNetwork: Flow.ChainID = .testnet
    @Published var walletCreationPhase: WalletCreationPhase = .notStarted
    @Published var walletCreationError: WalletCreationError?
    @Published var recoveryPhraseArray = [String]()
    @Published var findProfile: FINDProfile?
    @Published var currentTxId: Flow.ID?
    @Published var currentTxStatus: Flow.Transaction.Status?
    @Published var realm: Realm?
    @Published var walletGroup = WalletGroup()
    @Published var wallet: Wallet?
    @Published var deviceUUID: String
    @Published var pendingEnablement = false
    
    @Published private var excutedTxCount = 0
    private let config = UserDefaults.standard
    private let keychain = CryptoKeychain()
    
    
    init() {
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            self.deviceUUID = uuid
            
            do {
                self.realm = try Realm()
                
//                try keychain.clear()
//
                print("Realm is located at:", self.realm?.configuration.fileURL!)
//                try self.realm?.write {
//                    // Delete all objects from the realm.
//                    self.realm?.deleteAll()
//                }
                
                if let walletGrp = self.realm?.objects(WalletGroup.self).first {
                    if let device = self.realm?.objects(Device.self).first(where: ({$0.deviceUUID == self.deviceUUID})) {
                        if !device.enabled { self.pendingEnablement = true}
                        self.wallet = device.wallet.first
                    }
                    self.walletGroup = walletGrp
                }
                
                let _ = self.realm?.objects(WalletGroup.self).observe { (changes: RealmCollectionChange) in
                    var group = WalletGroup()
                    switch changes {
                    case .update(_, _, _, _):
                        if let walletGrp = self.realm?.objects(WalletGroup.self).first {
                            if let device = self.realm?.objects(Device.self).first(where: ({$0.deviceUUID == self.deviceUUID})) {
                                if !device.enabled { self.pendingEnablement = true}
                                self.wallet = device.wallet.first
                            }
                            group = walletGrp
                        }
                    case .initial(_):
                        self.walletGroup = group
                    case .error(let error):
                        print(error)
                    }
                }
            } catch {
                print(error)
            }
        } else {
            // TODO: Handle UUID not being readable
            self.deviceUUID = ""
        }
        
        flow.configure(chainID: flowNetwork)
    }
    
//    private func configureWalletConnect() {
//        Networking.configure(projectId: WC_PROJECT_ID, socketFactory: DefaultSocketFactory())
//
//        let metadata = AppMetadata(name: WC_APP_NAME, description: WC_APP_DESCRIPTION, url: WC_APP_URL, icons: WC_APP_ICONS)
//    }
    
    public func createMnemonicPhrase() {
        if walletCreationPhase == .notStarted {
            self.walletCreationPhase = .phraseAndPasswordCreation
            
            do {
                let phrase = try Mnemonic.generateMnemonic(strength: 128, language: .english)
                
                self.recoveryPhraseArray = phrase.components(separatedBy: " ")
            } catch {
                print(error)
            }
        }
    }
    
    public func createWallet(password: String) async {
        // Create Object to store in private DB
        let wallet = Wallet(flowChain: flowNetwork, walletAddress: "", accountUUID: UUID().uuidString)
        let device = Device(accountUUID: wallet.walletUUID, deviceUUID: self.deviceUUID, deviceName: await UIDevice.current.name)
        device.enabled = true
        wallet.devices.append(device)
        
        // Set phase
        await MainActor.run {
            self.walletCreationPhase = .generatingAccountAndDeviceKeys
        }
        
        // Generate Recovery Key
        var recoveryPublicKey: String
        do {
            let seedString = try Mnemonic.deterministicSeedString(from: recoveryPhraseArray.joined(separator: " "), passphrase: password, language: .english)
            let rawKey = try HKDF(password: Array(seedString.utf8), variant: .sha2(.sha256)).calculate()
            let recoveryPrivateKey = try P256.Signing.PrivateKey(rawRepresentation: rawKey)
            recoveryPublicKey = recoveryPrivateKey.publicKey.rawRepresentation.toHexString()
        } catch {
            print(error)
            self.walletCreationError = .recoveryKeyCreationError
            self.walletCreationPhase = .error
            return
        }
        
        // Generate & Save iCloud Account Key
        let accountPrivateKey = P256.Signing.PrivateKey()
        let accountPublicKey = accountPrivateKey.publicKey.rawRepresentation.toHexString()
        do {
            try keychain.set(accountPrivateKey, label: wallet.accountKey, sync: true)
        } catch {
            print("Acount Key: \(error)")
            
            await MainActor.run {
                try? self.keychain.clear()
                self.walletCreationError = .accountKeySaveError
                self.walletCreationPhase = .error
            }
            return
        }
        
        // Generate & Save Device Key Using Secure Enclave
        var devicePublicKey: String
        do {
            let devicePrivateKey = try SecureEnclave.P256.Signing.PrivateKey()
            devicePublicKey = devicePrivateKey.publicKey.rawRepresentation.toHexString()
            try keychain.set(devicePrivateKey, label: device.deviceKey, sync: false)
        } catch {
            print("Device Key: \(error)")
            await MainActor.run {
                try? self.keychain.clear()
                self.walletCreationError = WalletCreationError.deviceKeyCreationError
                self.walletCreationPhase = .error
            }
            return
        }
        
        
        await MainActor.run {
            self.walletCreationPhase = .creatingFlowAccount
        }
        // Send API Call to create Flow Account
        var accountTx: WalletCreateResponse?
        do {
            let data = WalletCreateRequest(recoveryPublicKey: recoveryPublicKey, accountPublicKey: accountPublicKey, devicePublicKey: devicePublicKey)
            let accountCreationRequest = try HTTPRequest(method: .post, URL(string: "\(ELLA_BASE_URL)/\(flowNetwork)/address")!)
            accountCreationRequest.body = .json(data)
            
            let accountTxResponse = try await accountCreationRequest.fetch()
            
            switch accountTxResponse.statusCode {
            case .ok:
                accountTx = try accountTxResponse.decode(WalletCreateResponse.self)
            default:
                await MainActor.run {
                    try? self.keychain.clear()
                    self.walletCreationError = .apiConntectionError
                    self.walletCreationPhase = .error
                }
                return
            }
        } catch {
            print(error)
            await MainActor.run {
                try? self.keychain.clear()
                self.walletCreationError = .apiConntectionError
                self.walletCreationPhase = .error
            }
            return
        }
        
        // Check TX Status
        if let txId = accountTx?.txId {
            var checkTxCount = 0
            var txError = false
            while walletCreationPhase != .walletCreated || txError {
                if checkTxCount < 100 { // TODO: THERE MUST BE A BETTER WAY TO WAIT FOR THE TX TO BE AVAILABLE
                    do {
                        let tx = try await flow.getTransactionResultById(id: Flow.ID(hex: txId))
                        
                        if tx.status == .sealed {
                            var eventFound = false
                            for event in tx.events {
                                if event.type == "flow.AccountCreated" {
                                    if let address = event.payload.fields?.value.toEvent()?.fields[0].value.decode() {
                                        wallet.walletAddress = (address as? String)!
                                    } else {
                                        await MainActor.run {
                                            try? self.keychain.clear()
                                            self.walletCreationPhase = .error
                                        }
                                        txError = true
                                    }

                                    eventFound = true
                                }
                            }
                            
                            if eventFound {
                                do {
                                    try await MainActor.run {
                                        try realm?.write {
                                            self.walletGroup.wallets.append(wallet)
                                            self.realm?.add(self.walletGroup, update: .modified)
                                        }
                                        
                                        self.walletCreationPhase = .walletCreated
                                        self.wallet = wallet
                                    }
                                } catch {
                                    print(error)
                                    try? self.keychain.clear()
                                    await MainActor.run {
                                        self.walletCreationPhase = .error
                                    }
                                    txError = true
                                }
                            } else {
                                try? self.keychain.clear()
                                await MainActor.run {
                                    self.walletCreationPhase = .error
                                }
                                txError = true
                            }
                        }
                    } catch {
                        checkTxCount += 1
                    }
                } else {
                    await MainActor.run {
                        try? self.keychain.clear()
                        self.walletCreationPhase = .error
                    }
                    txError = true
                }
            }
        }
    }
    
    public func linkWallet() {
        
    }
    
    
    public func signOut() {
        do {
            guard let device = self.wallet?.devices.first(where: ({$0.deviceUUID == self.deviceUUID})) else {
                return
            }
            
            guard let wallet = self.wallet else {
                return
            }
            
            try keychain.delete(label: device.deviceUUID, type: .generic)
            self.showSettingsMenu = false
            self.findProfile = nil
            self.wallet = nil
            
            try self.realm?.write {
                if wallet.devices.count == 1 {
                    try keychain.delete(label: self.wallet?.accountKey ?? "", type: .key)
                    wallet.isDeleted = true
                }
                
                device.isDeleted = true
            }
        } catch {
            print(error)
        }
    }
    
    public func executeFlowTx(transaction: String, flowArguments: [Flow.Argument]) async throws {
        guard let wallet = self.wallet else {
            throw WalletError.walletNotSelected
        }
        let signers = try await EllaSigner(wallet: wallet)
        let walletAddr = Flow.Address(hex: wallet.walletAddress)
        var unsignedTx = try await flow.buildTransaction{
            cadence {
                transaction
            }
            
            proposer {
                Flow.TransactionProposalKey(address: walletAddr, keyIndex: signers[0].keyIndex)
            }
            
            authorizers {
                walletAddr
            }
            
            arguments {
                flowArguments
            }
        }
        
        let signedTX = try await unsignedTx.sign(signers: signers)
        
        let result = try await flow.sendTransaction(transaction: signedTX)
        
        await MainActor.run {
            self.excutedTxCount += 1
            self.currentTxId = result
        }
        
        print(result.hex)
    }
    
    private func getFindProfile() async throws {
        guard let wallet = self.wallet else {
            throw WalletError.walletNotSelected
        }
        
        let profile = await reverseLookupProfile(address: wallet.walletAddress)
        
        await MainActor.run {
            self.findProfile = profile
        }
    }
}
