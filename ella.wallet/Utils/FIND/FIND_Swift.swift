//
//  FIND_Swift.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/25/23.
//

import Foundation
import Flow

public func reverseLookupProfile(address: String) async -> FINDProfile? {
    do {
        let result = try await flow.executeScriptAtLatestBlock(script: Flow.Script(text: FindScripts.reverseLookupProfile.rawValue), arguments: [.address(Flow.Address(hex: address))])
        
        return try result.decode(FINDProfile.self)
    } catch {
        print(error)
        return nil
    }
}
