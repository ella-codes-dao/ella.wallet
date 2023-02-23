//
//  ContentView.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/22/23.
//

import SwiftUI

struct RouterView: View {
    @EnvironmentObject var walletController: WalletController
    
    var body: some View {
        Group {
            if (walletController.walletInitiliazed) {
                NavigationStack {
                    WalletTabView()
                }
            } else {
                NavigationStack {
                    WelcomeView()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RouterView()
    }
}
