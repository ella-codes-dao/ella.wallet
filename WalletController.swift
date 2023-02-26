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
//import WalletConnectNetworking
//import Web3Wallet

class WalletController: ObservableObject {
    @Published var flowNetwork: Flow.ChainID = .testnet
    @Published var accountInitiliazed = false
    @Published var walletInitiliazed = false
    @Published var walletCreationPhase: WalletCreationPhase = .notStarted
    @Published var walletCreationError: WalletCreationError?
    @Published var recoveryPhraseArray = [String]()
    @Published var walletAddress = ""
    @Published var findProfile: FINDProfile?
    @Published var currentTxId: Flow.ID?
    @Published var currentTxStatus: Flow.Transaction.Status?
    
    private let config = UserDefaults.standard
    private let keychain = CryptoKeychain()
    private var uuid: String
    
    init() {
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            self.uuid = uuid
            
//            try? keychain.clear()
            
            if let _: P256.Signing.PrivateKey = try? keychain.get(label: "ella.wallet-account-key") {
                self.accountInitiliazed = true
                
                if let _: SecureEnclave.P256.Signing.PrivateKey = try? keychain.get(label: "ella.wallet-\(uuid)-key") {
                    if let keychainAddress = config.object(forKey: "walletAddress") as? String {
                        self.walletAddress = keychainAddress
                    }
                    self.walletInitiliazed = true

                    Task {
                        await getFindProfile()
                    }
                }
            }
        } else {
            // TODO: Handle UUID not being readable
            self.uuid = ""
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
            try keychain.set(accountPrivateKey, label: "ella.wallet-account-key", sync: true)
        } catch {
            print(error)
            
            await MainActor.run {
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
            try keychain.set(devicePrivateKey, label: "ella.wallet-\(uuid)-key", sync: false)
        } catch {
            print(error)
            await MainActor.run {
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
                    self.walletCreationError = .apiConntectionError
                    self.walletCreationPhase = .error
                }
                return
            }
        } catch {
            print(error)
            await MainActor.run {
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
                                        config.set(address as? String, forKey: "walletAddress")
                                        await MainActor.run {
                                            self.walletAddress = (address as? String)!
                                        }
                                    } else {
                                        await MainActor.run {
                                            self.walletCreationPhase = .error
                                        }
                                        txError = true
                                    }

                                    eventFound = true
                                }
                            }
                            
                            if eventFound {
                                await MainActor.run {
                                    self.walletCreationPhase = .walletCreated
                                }
                            } else {
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
                        self.walletCreationPhase = .error
                    }
                    txError = true
                }
            }
        }
        
        await MainActor.run {
            self.walletCreationPhase = .walletCreated
            self.walletInitiliazed = true
        }
    }
    
    
    public func signOut() {
        guard self.walletInitiliazed == true else {
            return
        }

//        keychain.delete("ella.wallet-\(uuid)-key")
        do {
            try keychain.clear()
            
            self.walletInitiliazed = false
        } catch {
            print(error)
        }
    }
    
    public func executeFlowTx(transaction: String, flowArguments: [Flow.Argument]) async throws {
        let walletAddr = Flow.Address(hex: self.walletAddress)
        let signers = try await EllaSigner(address: walletAddress)
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
            self.currentTxId = result
        }
        
        print(result.hex)
    }
    
    private func getFindProfile() async {
        let profile = await reverseLookupProfile(address: self.walletAddress)
        
        await MainActor.run {
            self.findProfile = profile
        }
    }

//    internal func printResultCode(resultCode: OSStatus) {
//            // See: https://www.osstatus.com/
//            switch resultCode {
//            case errSecSuccess:
//                print("Keychain Status: No error.")
//            case errSecUnimplemented:
//                print("Keychain Status: Function or operation not implemented.")
//            case errSecIO:
//                print("Keychain Status: I/O error (bummers)")
//            case errSecOpWr:
//                print("Keychain Status: File already open with with write permission")
//            case errSecParam:
//                print("Keychain Status: One or more parameters passed to a function where not valid.")
//            case errSecAllocate:
//                print("Keychain Status: Failed to allocate memory.")
//            case errSecUserCanceled:
//                print("Keychain Status: User canceled the operation.")
//            case errSecBadReq:
//                print("Keychain Status: Bad parameter or invalid state for operation.")
//            case errSecInternalComponent:
//                print("Keychain Status: Internal Component")
//            case errSecNotAvailable:
//                print("Keychain Status: No keychain is available. You may need to restart your computer.")
//            case errSecDuplicateItem:
//                print("Keychain Status: The specified item already exists in the keychain.")
//            case errSecItemNotFound:
//                print("Keychain Status: The specified item could not be found in the keychain.")
//            case errSecInteractionNotAllowed:
//                print("Keychain Status: User interaction is not allowed.")
//            case errSecDecode:
//                print("Keychain Status: Unable to decode the provided data.")
//            case errSecAuthFailed:
//                print("Keychain Status: The user name or passphrase you entered is not correct.")
//            default:
//                print("Keychain Status: Unknown. (\(resultCode))")
//            }
//        }
}
