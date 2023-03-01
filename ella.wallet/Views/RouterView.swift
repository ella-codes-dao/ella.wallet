//
//  ContentView.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/22/23.
//

import SwiftUI
import RealmSwift

struct RouterView: View {
    @EnvironmentObject var walletController: WalletController
    
    var body: some View {
        if walletController.wallet == nil {
            WelcomeView()
        } else {
            WalletRouterView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RouterView()
    }
}
