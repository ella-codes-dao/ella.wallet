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

func EllaSigner(address: String) async throws -> [EllaSignerKey] {
    guard let accountSigner = await EllaSignerKey(addr: address, type: .accountKey) else {
        throw EllaSignerErrors.unableToGetAccountKey
    }
    
    guard let deviceSigner = await EllaSignerKey(addr: address, type: .deviceKey) else {
        throw EllaSignerErrors.unableToGetDeviceUUID
    }
    
    return [accountSigner, deviceSigner]
}

struct EllaSignerKey: FlowSigner {
    private var keyType: EllaKeyType
    
    var address: Flow.Address
    
    var keyIndex: Int = 0
    
    func sign(transaction: Flow.Transaction, signableData: Data) async throws -> Data {
        var signedMsg: Data
        switch keyType {
        case .accountKey:
            guard let key: P256.Signing.PrivateKey = try CryptoKeychain().get(label: "ella.wallet-account-key") else {
                throw EllaSignerErrors.unableToGetAccountKey
            }
            
            signedMsg = try key.signature(for: signableData).rawRepresentation
        case .deviceKey:
            guard let uuid = await UIDevice.current.identifierForVendor?.uuidString else {
                throw EllaSignerErrors.unableToGetDeviceUUID
            }
            
            guard let key: SecureEnclave.P256.Signing.PrivateKey = try CryptoKeychain().get(label: "ella.wallet-\(uuid)-key") else {
                throw EllaSignerErrors.unableToGetDeviceUUID
            }
            
            signedMsg = try key.signature(for: signableData).rawRepresentation
        }
        
        return signedMsg
    }
    
    init?(addr: String, type: EllaKeyType) async {
        self.keyType = type
        self.address = Flow.Address(hex: addr)
        
        do {
            var publicKeyValue: String
            switch type {
            case .accountKey:
                guard let key: P256.Signing.PrivateKey = try CryptoKeychain().get(label: "ella.wallet-account-key") else {
                    throw EllaSignerErrors.unableToGetAccountKey
                }
                
                publicKeyValue = key.publicKey.rawRepresentation.toHexString()
            case .deviceKey:
                guard let uuid = await UIDevice.current.identifierForVendor?.uuidString else {
                    throw EllaSignerErrors.unableToGetDeviceUUID
                }
                
                guard let key: SecureEnclave.P256.Signing.PrivateKey = try CryptoKeychain().get(label: "ella.wallet-\(uuid)-key") else {
                    throw EllaSignerErrors.unableToGetDeviceUUID
                }
                
                publicKeyValue = key.publicKey.rawRepresentation.toHexString()
            }
            
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

enum EllaKeyType: String {
    case accountKey
    case deviceKey
}

enum EllaSignerErrors: Error {
    case unableToGetAccountKey
    case unableToGetDeviceKey
    case unableToGetDeviceUUID
}
