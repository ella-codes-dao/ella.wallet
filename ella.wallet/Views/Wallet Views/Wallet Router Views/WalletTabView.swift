//
//  WalletTabView.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/22/23.
//

import SwiftUI

struct WalletTabView: View {
    @EnvironmentObject var walletController: WalletController
    
    var tabs = ["wallet", "ellaCard", "nft", "dapp"]
    
    @State var selectedTab = "wallet"
    
    // Location of each curve
    @State var xAxis: CGFloat = 0
    @Namespace var animation
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            TabView(selection: $selectedTab) {
                DashboardView()
                    .tag("wallet")
                
                Text("ella.card View")
                    .tag("ellaCard")
                
                Text("NFT View")
                    .tag("nft")
                
                DappSelectorView()
                    .tag("dapp")
            }
            .padding(.horizontal, 20)
            
            // custom tab bar
            HStack(spacing: 0) {
                ForEach(tabs, id: \.self) { image in
                    GeometryReader { reader in
                        Button(action: {
                            withAnimation {
                                selectedTab = image
                                xAxis = reader.frame(in: .global).minX
                            }
                        }, label: {
                            if image == "nft" {
                                Image(image)
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 38.0, height: 38.0)
                                    .foregroundColor(selectedTab == image ? .walletPrimary : .gray)
                                    .padding(selectedTab == image ? 7 : 0)
                                    .background(Color.lightBackground.opacity(selectedTab == image ? 1 : 0).clipShape(Circle()))
                                    .matchedGeometryEffect(id: image, in: animation)
                                    .offset(x: selectedTab == image ? -10 : 0, y: selectedTab == image ? -50 : -7)
                            } else {
                                Image(image)
                                    .resizable()
                                    .renderingMode(.template)
                                    .imageScale(.large)
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 22.0, height: 22.0)
                                    .foregroundColor(selectedTab == image ? .walletPrimary : .gray)
                                    .padding(selectedTab == image ? 15 : 0)
                                    .background(Color.lightBackground.opacity(selectedTab == image ? 1 : 0).clipShape(Circle()))
                                    .matchedGeometryEffect(id: image, in: animation)
                                    .offset(x: selectedTab == image ? -10 : 0, y: selectedTab == image ? -50 : 0)
                            }
                        })
                        .onAppear(perform: {
                            if image == tabs.first {
                                xAxis = reader.frame(in: .global).minX
                            }
                        })
                    }
                    .frame(width: 25.0, height: 30.0)
                    if image != tabs.last { Spacer() }
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical)
            .background(Color.lightBackground.clipShape(CustomTabBarShape(xAxis: xAxis)).cornerRadius(12.0))
            .padding(.horizontal)
            .padding(.bottom , UIApplication.shared.windows.first?.safeAreaInsets.bottom)
        }
        .ignoresSafeArea(.all, edges: .all)
    }
}

struct WalletTabView_Previews: PreviewProvider {
    static var previews: some View {
        WalletTabView()
    }
}
