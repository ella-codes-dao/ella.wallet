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

class WalletController: ObservableObject {
    @Published var walletInitiliazed = false
    @Published var walletCreationPhase: WalletCreationPhase = .notStarted
    @Published var walletCreationError: WalletCreationError?
    @Published var recoveryPhraseArray = [String]()
    
    private let keychain = KeychainSwift()
    
    init() {
        keychain.synchronizable = true
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
    
    public func createWallet(password: String) {
        self.walletCreationPhase = .generatingAccountAndDeviceKeys
        // Generate Recovery Key
        do {
            let seedString = try Mnemonic.deterministicSeedString(from: recoveryPhraseArray.joined(separator: " "), passphrase: password, language: .english)
            let rawKey = try HKDF(password: Array(password.utf8), variant: .sha2(.sha256)).calculate()
            let recoveryPrivateKey = try P256.Signing.PrivateKey(rawRepresentation: rawKey)
            let recoveryPublicKey = recoveryPrivateKey.publicKey.rawRepresentation.toHexString()
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
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            do {
                let devicePrivateKey = try SecureEnclave.P256.Signing.PrivateKey()
                let devicePublicKey = devicePrivateKey.publicKey.rawRepresentation.toHexString()
                keychain.set(devicePrivateKey.dataRepresentation, forKey: "ella.wallet-\(uuid)-key", withAccess: .accessibleWhenPasscodeSetThisDeviceOnly)
            } catch {
                print(error)
                self.walletCreationError = WalletCreationError.deviceKeyCreationError
                self.walletCreationPhase = .error
                return
            }
        } else {
            self.walletCreationError = WalletCreationError.unableToGetDeviceID
            self.walletCreationPhase = .error
            return
        }
        
        
        self.walletCreationPhase = .creatingFlowAccount
        // TODO: Send API Call to create Flow Account
        
        self.walletCreationPhase = .walletCreated
        
        // TODO: Verify Account Created
        
        self.walletInitiliazed = true
    }
}
