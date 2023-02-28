//
//  WalletSideMenuView.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/27/23.
//

import SwiftUI

struct WalletSideMenuView: View {
    @EnvironmentObject var walletController: WalletController
    @Binding var menuOpened: Bool
    let width: CGFloat

    
    var body: some View {
        // Dimmed Background View
        GeometryReader { _ in
            EmptyView()
        }
        .background(Color.walletPrimary.opacity(0.5))
        .opacity(self.menuOpened ? 1 : 0)
        .animation(Animation.easeIn.delay(0.25))
        .onTapGesture {
            self.menuOpened.toggle()
        }
        
        
        // Menu Content
        HStack {
            SettingsView()
                .frame(width: width)
                .offset(x: menuOpened ? 0 : -width)
                .animation(.default)
            
            Spacer()
        }
    }
}
