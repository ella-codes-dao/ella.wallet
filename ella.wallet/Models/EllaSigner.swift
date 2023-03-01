//
//  EllaSigner.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/25/23.
//

import Foundation
import Flow
import CryptoKeychain
import CryptoKit
import UIKit
import RealmSwift

func EllaSigner(wallet: Wallet) async throws -> [AnyFlowSigner] {
    guard let accountSigner = await EllaAccountSigner(wallet: wallet) else {
        throw EllaSignerErrors.unableToGetAccountKey
    }
    
    guard let uuid = await UIDevice.current.identifierForVendor?.uuidString else {
        throw EllaSignerErrors.unableToGetDeviceUUID
    }
    
    guard let device = wallet.devices.first(where: ({ $0.deviceUUID == uuid })) else {
        throw EllaSignerErrors.unableToGetDeviceKey
    }
    
    guard let deviceSigner = await EllaDeviceSigner(wallet: wallet, keyId: device.deviceKey) else {
        throw EllaSignerErrors.unableToGetDeviceUUID
    }
    
    return [accountSigner, deviceSigner]
}

struct EllaAccountSigner: FlowSigner {
    private var wallet: Wallet
    
    var address: Flow.Address
    
    var keyIndex: Int = 0
    
    func sign(transaction: Flow.Transaction, signableData: Data) async throws -> Data {
        guard let key: P256.Signing.PrivateKey = try CryptoKeychain().get(label: wallet.accountKey) else {
            throw EllaSignerErrors.unableToGetAccountKey
        }
        
        let signedMsg = try key.signature(for: signableData).rawRepresentation
        
        return signedMsg
    }
    
    init?(wallet: Wallet) async {
        self.wallet = wallet
        self.address = Flow.Address(hex: wallet.walletAddress)
        
        do {
            guard let key: P256.Signing.PrivateKey = try CryptoKeychain().get(label: wallet.accountKey) else {
                throw EllaSignerErrors.unableToGetAccountKey
            }
            
            let publicKeyValue = key.publicKey.rawRepresentation.toHexString()
            
            let account = try await flow.getAccountAtLatestBlock(address: self.address)
            for key in account.keys {
                if publicKeyValue == key.publicKey.hex {
                    self.keyIndex = key.index
                }
            }
        } catch {
            print(error)
            return nil
        }
    }
}

struct EllaDeviceSigner: FlowSigner {
    private var deviceKey: String
    
    var address: Flow.Address
    
    var keyIndex: Int = 0
    
    func sign(transaction: Flow.Transaction, signableData: Data) async throws -> Data {
        guard let key: SecureEnclave.P256.Signing.PrivateKey = try CryptoKeychain().get(label: deviceKey) else {
            throw EllaSignerErrors.unableToGetDeviceUUID
        }
        
        let signedMsg = try key.signature(for: signableData).rawRepresentation
        
        return signedMsg
    }
    
    init?(wallet: Wallet, keyId: String) async {
        self.deviceKey = keyId
        self.address = Flow.Address(hex: wallet.walletAddress)
        
        do {
            guard let key: P256.Signing.PrivateKey = try CryptoKeychain().get(label: deviceKey) else {
                throw EllaSignerErrors.unableToGetAccountKey
            }
            
            let publicKeyValue = key.publicKey.rawRepresentation.toHexString()
            
            let account = try await flow.getAccountAtLatestBlock(address: self.address)
            for key in account.keys {
                if publicKeyValue == key.publicKey.hex {
                    self.keyIndex = key.index
                }
            }
        } catch {
            print(error)
            return nil
        }
    }
}

protocol AnyFlowSigner: FlowSigner {}

extension EllaAccountSigner: AnyFlowSigner {}
extension EllaDeviceSigner: AnyFlowSigner {}

enum EllaSignerErrors: Error {
    case unableToGetAccountKey
    case unableToGetDeviceKey
    case unableToGetDeviceUUID
}
