//
//  WalletRouterView.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/27/23.
//

import SwiftUI

struct WalletRouterView: View {
    @EnvironmentObject var walletController: WalletController
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: { walletController.showSettingsMenu.toggle() }) {
                        Image("settingsGear")
                            .resizable()
                            .renderingMode(.template)
                            .imageScale(.large)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 22.0, height: 22.0)
                            .foregroundColor(.walletPrimary)
                    }
                    
                    Spacer ()
                    
                    Text("ella.wallet")
                }
                .padding(.bottom, 10)
                .padding(.horizontal, 30)
                
                switch walletController.selectedDAPP {
                case .none:
                    WalletTabView()
                case .find:
                    Spacer()
                    Text(".find DAPP View")
                    Spacer()
                case .float:
                    Spacer()
                    Text("FLOAT DAPP View")
                    Spacer()
                }
            }
            
            WalletSideMenuView(menuOpened: $walletController.showSettingsMenu, width: UIScreen.main.bounds.width/1.3)
        }
    }
}

struct WalletRouterView_Previews: PreviewProvider {
    static var previews: some View {
        WalletRouterView()
    }
}
