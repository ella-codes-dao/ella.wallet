//
//  WalletCreation.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/23/23.
//

import Foundation

enum WalletCreationPhase {
    case notStarted
    case phraseAndPasswordCreation
    case generatingAccountAndDeviceKeys
    case creatingFlowAccount
    case walletCreated
    case error
}

struct WalletCreateRequest: Codable {
    var recoveryPublicKey: String
    var accountPublicKey: String
    var devicePublicKey: String
}

struct WalletCreateResponse: Codable {
    var status: String
    var msg: String?
    var txId: String?
}
