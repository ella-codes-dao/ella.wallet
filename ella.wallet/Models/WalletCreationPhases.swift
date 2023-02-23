//
//  WalletCreationPhases.swift
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
