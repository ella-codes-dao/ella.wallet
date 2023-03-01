//
//  SwitchWalletView.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/28/23.
//

import SwiftUI
import RealmSwift
import Flow

struct SwitchWalletView: View {
    @EnvironmentObject var walletController: WalletController
    @Binding var isOpen: Bool
    @State var newWalletSheetOpen = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: { isOpen.toggle() }, label: {
                Image(systemName: "arrow.left")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
            })
                .frame(width: 22.0, height: 22.0)
                .padding(.vertical, 15)
            
            List {
                Section("Wallets Configured On Device") {
                    ForEach(walletController.walletGroup.wallets.where(({$0.devices.deviceUUID == walletController.deviceUUID}))) { wallet in
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
                                
                                Spacer()
                                
                                if walletController.wallet?.walletAddress == wallet.walletAddress {
                                    Image(systemName: "checkmark.circle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                }
                            }
                        }
                    }
                }
                
                Section("Wallets Not Configured On Device") {
                    ForEach(walletController.walletGroup.wallets.where(({$0.devices.deviceUUID != walletController.deviceUUID}))) { wallet in
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
                                
                                Spacer()
                                
                                if walletController.wallet?.walletAddress == wallet.walletAddress {
                                    Image(systemName: "checkmark.circle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                }
                            }
                        }
                    }
                }
            }
            
            Button(action: { newWalletSheetOpen.toggle() }, label: {
                Text("Create A New Wallet")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.black)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .padding(.vertical, 15)
                    .background(
                        Color.walletPrimary
                    )
                    .cornerRadius(20)
            })
            .sheet(isPresented: $newWalletSheetOpen) {
                CreateWallet(isOpen: $newWalletSheetOpen)
                    .padding(.top, 10)
                    .padding(.horizontal, 10)
            }
        }
        .padding(.horizontal, 20)
    }
}
