//
//  WalletErrors.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/23/23.
//

import Foundation

enum WalletCreationError: Error {
    case recoveryKeyCreationError
    case accountKeyCreationError
    case deviceKeyCreationError
    case unableToGetDeviceID
}
