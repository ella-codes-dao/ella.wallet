//
//  LinkWalletView.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/28/23.
//

import SwiftUI
import RealmSwift
import Flow

struct LinkWalletView: View {
    @EnvironmentObject var walletController: WalletController
    @ObservedResults(WalletGroup.self) var walletGroup
    
    var body: some View {
        List {
            Section("Wallets Not Configured On Device") {
                ForEach(walletGroup.first!.wallets.where(({$0.devices.deviceUUID != walletController.deviceUUID}))) { wallet in
                    Button(action: {}) {
                        HStack {
                            Image("flow")
                                .resizable()
                                .clipShape(Circle())
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                            VStack(alignment: .leading) {
                                Text(wallet.name ?? "My Wallet")
                                    .font(.headline)
                                Text(wallet.walletAddress)
                                    .font(.subheadline)
                            }
                            
                            if Flow.ChainID(name: wallet.flowChain) != .mainnet {
                                Text(wallet.flowChain.uppercased())
                                    .font(.body)
                                    .padding(5)
                                    .background(Color.orange)
                                    .foregroundColor(.black)
                                    .cornerRadius(15)
                            }
                        }
                    }
                }
            }
        }
    }
}
