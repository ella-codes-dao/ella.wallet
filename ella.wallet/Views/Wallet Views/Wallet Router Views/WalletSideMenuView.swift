//
//  WalletSideMenuView.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/27/23.
//

import SwiftUI
import CachedAsyncImage

struct WalletSideMenuView: View {
    @EnvironmentObject var walletController: WalletController
    @Binding var menuOpened: Bool
    let width: CGFloat

    
    var body: some View {
        // Dimmed Background View
        GeometryReader { _ in
            EmptyView()
        }
        .background(Color.walletPrimary.opacity(0.3))
        .opacity(self.menuOpened ? 1 : 0)
        .animation(Animation.easeIn)
        .onTapGesture {
            self.menuOpened.toggle()
        }
        
        
        // Menu Content
        HStack {
            ZStack {
                Color.black.ignoresSafeArea(.all)
                
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
                            Text((walletController.findProfile?.name ?? walletController.wallet?.walletAddress) ?? "")
                                .font(.title2)
                                .lineLimit(1)
                            Text("Some other info probably")
                                .font(.subheadline)
                        }
                    }
                    
                    switch walletController.selectedDAPP {
                    case .none:
                        SettingsView()
                    default:
                        List {
                            Button {
                                walletController.selectedDAPP = .none
                                walletController.showSettingsMenu = false
                            } label: {
                                Text("Back To Wallet")
                            }

                        }
                    }
                    
                    Spacer()
                }
            }
            .frame(width: width)
            .offset(x: menuOpened ? 0 : -width)
            .animation(.default)
            
            Spacer()
        }
    }
}
