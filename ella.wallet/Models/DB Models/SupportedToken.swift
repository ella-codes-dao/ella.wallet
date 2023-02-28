//
//  SupportedTokens.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/27/23.
//

import RealmSwift

class SupportedToken: Object, Codable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var desc: String
    @Persisted var symbol: String
    @Persisted var image: String
    @Persisted var setupTx: String?
    @Persisted var enabled: Bool
    
    convenience init(name: String, desc: String, symbol: String, image: String, setupTx: String?, enabled: Bool) {
        self.init()
        self.name = name
        self.desc = desc
        self.symbol = symbol
        self.image = image
        self.setupTx = setupTx
        self.enabled = enabled
    }
}

let BLT = SupportedToken(name: "BLT", desc: "The utility and governance token of Blocto, which serves as the foundation of its ecosystem", symbol: "$BLT", image: "blt", setupTx: nil, enabled: false)

let EMERALD = SupportedToken(name: "Emerald (TBC)", desc: "Fungible token on Flow native to Emerald City DAO", symbol: "$EMERALD", image: "emerald", setupTx: nil, enabled: true)

let FLOW = SupportedToken(name: "Flow", desc: "Flow's native currency which is key to maintaining and operating the Flow blockchain. It can be integrated into dApps for payments, transactions and earning rewards", symbol: "$FLOW", image: "flow", setupTx: nil, enabled: true)

let FUSD = SupportedToken(name: "FUSD", desc: "The first USD-backed stablecoin issued as a fungible token on Flow backed by Prime Trust", symbol: "$FUSD", image: "fusd", setupTx: nil, enabled: false)

let JRX = SupportedToken(name: "JRX", desc: "The $JRX Token powers the economy across the network of games built on Joyride", symbol: "$JRX", image: "jrx", setupTx: nil, enabled: false)

let MY = SupportedToken(name: "MY", desc: "The only native utility token of Mynft", symbol: "$MY", image: "my", setupTx: nil, enabled: false)

let REVV = SupportedToken(name: "REVV", desc: "REVV is the main utility token and in-game currency of the branded motorsports games produced by Animoca Brands", symbol: "$REVV", image: "revv", setupTx: nil, enabled: false)

let RLY = SupportedToken(name: "RLY", desc: "The RLY token is an ERC-20 native token that powers the RLY Network. RLY is multi-chain and can also be obtained on other blockchains through official bridges and canonical swaps maintained by the RLY Network Association.", symbol: "$RLY", image: "rly", setupTx: nil, enabled: false)

let USDC = SupportedToken(name: "USDC", desc: "USDC is a stablecoin that powers NBA Top Shot and will soon become available to the non-custodial Flow ecosystem", symbol: "$USDC", image: "usdc", setupTx: nil, enabled: true)
