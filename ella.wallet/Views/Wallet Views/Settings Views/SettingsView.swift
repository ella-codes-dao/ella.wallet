//
//  SettingsView.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/25/23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var walletController: WalletController
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image(systemName: "person.circle")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 66.0, height: 66.0)
                }
                
                List {
                    Button(action: { walletController.signOut() }) {
                        Text("Sign Out")
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
