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
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    if walletController.findProfile?.avatar != nil {
                        CachedAsyncImage(url: URL(string: walletController.findProfile?.avatar ?? ""), scale: 2) { image in
                            image
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 66.0, height: 66.0)
                        } placeholder: {
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 66.0, height: 66.0)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(walletController.findProfile?.name ?? walletController.walletAddress)
                            .font(.title2)
                            .lineLimit(1)
                        Text("Some other info probably")
                            .font(.subheadline)
                    }
                }
                .padding(.horizontal, 30)
                
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
