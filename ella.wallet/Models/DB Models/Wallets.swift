//
//  Wallets.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/28/23.
//

import Foundation
import RealmSwift
import Flow
import IceCream

/// Represents a collection of wallets.
final class WalletGroup: Object, ObjectKeyIdentifiable {
    @Persisted var id = UUID().uuidString
    /// The collection of Items in this group.
    @Persisted var wallets = RealmSwift.List<Wallet>()
    
    @Persisted var isDeleted: Bool = false
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension WalletGroup: CKRecordConvertible & CKRecordRecoverable {}

/// An individual wallet. Part of an `WalletGroup`.
final class Wallet: Object, ObjectKeyIdentifiable {
    @Persisted var id = UUID().uuidString
    /// The display name of the wallet
    @Persisted var name: String?
    /// A flag indicating which chain ID the wallet belongs to.
    @Persisted var flowChain: String
    /// The address of the wallet on the Flow Blockchain
    @Persisted var walletAddress: String
    /// the UUID of the wallet for internal ussage
    @Persisted var walletUUID: String
    /// The keychain ID of the wallets account key
    @Persisted var accountKey: String
    /// List of devices and keys for wallets varies device keys
    @Persisted var devices: List<Device>
    
    @Persisted var isDeleted: Bool = false
    
    convenience init(name: String? = nil, flowChain: Flow.ChainID, walletAddress: String, accountUUID: String) {
        self.init()
        self.name = name
        self.flowChain = flowChain.name
        self.walletAddress = walletAddress
        self.walletUUID = accountUUID
        self.accountKey = "ella.wallet-account-\(accountUUID)"
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension Wallet: CKRecordConvertible & CKRecordRecoverable {}

/// Represents an individual wallet device key, Part of a `Wallet`
final class Device: Object {
    @Persisted var id = UUID().uuidString
    @Persisted var deviceUUID: String
    @Persisted var deviceKey: String
    @Persisted var deviceName: String
    @Persisted var enabled: Bool = false
    
    // Backlink to the wallet.
    @Persisted(originProperty: "devices") var wallet: LinkingObjects<Wallet>
    
    @Persisted var isDeleted: Bool = false
    
    convenience init(accountUUID: String, deviceUUID: String, deviceName: String) {
        self.init()
        self.deviceUUID = deviceUUID
        self.deviceKey = "ella.wallet-device-\(accountUUID)-\(deviceUUID)"
        self.deviceName = deviceName
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension Device: CKRecordConvertible & CKRecordRecoverable {}
