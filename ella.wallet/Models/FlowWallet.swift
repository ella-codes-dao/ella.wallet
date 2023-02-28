//
//  FlowWallet.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/26/23.
//

import RealmSwift

class FlowWallet: Object, Codable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var address: String
}
