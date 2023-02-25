//
//  WalletController.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/22/23.
//

import Foundation
import MnemonicSwift
import CryptoSwift
import CryptoKit
import KeychainSwift
import UIKit
import RealHTTP

class WalletController: ObservableObject {
    @Published var flowNetwork: FlowNetworks = .testnet
    @Published var walletInitiliazed = false
    @Published var walletCreationPhase: WalletCreationPhase = .notStarted
    @Published var walletCreationError: WalletCreationError?
    @Published var recoveryPhraseArray = [String]()
    
    private let keychain = KeychainSwift()
    private var uuid: String?
    
    init() {
        keychain.synchronizable = true
        
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            self.uuid = uuid
            
            if keychain.getData("ella.wallet-account-key") != nil {
                if keychain.getData("ella.wallet-\(uuid)-key") != nil {
                    self.walletInitiliazed = true
                }
            }
        } else {
            // TODO: Handle error if UUID not available
        }
    }
    
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
        keychain.set(accountPrivateKey.rawRepresentation, forKey: "ella.wallet-account-key", withAccess: .accessibleWhenUnlocked)
        
        // Generate & Save Device Key Using Secure Enclave
        var devicePublicKey: String
        do {
            let devicePrivateKey = try SecureEnclave.P256.Signing.PrivateKey()
            devicePublicKey = devicePrivateKey.publicKey.rawRepresentation.toHexString()
            keychain.set(devicePrivateKey.dataRepresentation, forKey: "ella.wallet-\(String(describing: uuid))-key", withAccess: .accessibleWhenPasscodeSetThisDeviceOnly)
        } catch {
            print(error)
            self.walletCreationError = WalletCreationError.deviceKeyCreationError
            self.walletCreationPhase = .error
            return
        }
        
        
        await MainActor.run {
            self.walletCreationPhase = .creatingFlowAccount
        }
        // Send API Call to create Flow Account
        var accountTx: WalletCreateResponse?
        do {
            let data = WalletCreateRequest(recoveryPublicKey: recoveryPublicKey, accountPublicKey: accountPublicKey, devicePublicKey: devicePublicKey)
            let accountCreationRequest = try HTTPRequest(method: .post, URL(string: "\(EllaBackendBaseURL)/\(flowNetwork.rawValue)/address")!)
            accountCreationRequest.body = .json(data)
            
            let accountTxResponse = try await accountCreationRequest.fetch()
            
            switch accountTxResponse.statusCode {
            case .ok:
                accountTx = try accountTxResponse.decode(WalletCreateResponse.self)
            default:
                await MainActor.run {
                    self.walletCreationError = .errorContactingAPI
                    self.walletCreationPhase = .error
                }
                return
            }
        } catch {
            print(error)
            await MainActor.run {
                self.walletCreationError = .errorContactingAPI
                self.walletCreationPhase = .error
            }
            return
        }
        
        // Check TX Status
        if let txId = accountTx {
            print(txId)
        }
        
        await MainActor.run {
            self.walletCreationPhase = .walletCreated
        }
        // TODO: Verify Account Created
        
        await MainActor.run {
            self.walletInitiliazed = true
        }
    }
}
