//
//  FINDProfile.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/25/23.
//

import Foundation

public struct FINDProfile: Decodable, Hashable {
    public var findName: String
    public var name: String
    public var description: String
    public var tags: [String]
    public var avatar: String
    public var links: [String]
}
