//
//  SettingsView.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/25/23.
//

import SwiftUI
import CachedAsyncImage

struct SettingsView: View {
    @EnvironmentObject var walletController: WalletController
    
    @State var switchWalletsPresented = false
    
    var body: some View {
        VStack {
            List {
                Button {
                    switchWalletsPresented.toggle()
                    walletController.showSettingsMenu.toggle()
                } label: {
                    Text("Switch Wallets")
                }

                Button(action: { walletController.signOut() }) {
                    Text("Sign Out")
                }
            }
            .sheet(isPresented: $switchWalletsPresented) {
                SwitchWalletView(isOpen: $switchWalletsPresented)
            }
        }
    }
}
