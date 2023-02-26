//
//  DashboardCardView.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/25/23.
//

import SwiftUI

struct DashboardCardView: View {
    @EnvironmentObject var walletController: WalletController
    @State private var detailsVisible = false
    @State private var showCreateProfileSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color.lightBackground
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(walletController.findProfile?.name ?? "Profile Not Created")
                        Spacer()
                        Image(systemName: "qrcode.viewfinder")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22.0, height: 22.0)
                            .foregroundColor(.walletPrimary)
                    }
                    
                    Spacer()
                    
                    // Total Asset Value
                    Text(detailsVisible ? "$123.005" : "$xxx.xxx")
                    
                    Spacer()
                    
                    // Address
                    HStack {
                        Text(detailsVisible ? walletController.walletAddress : "******************")
                        Spacer()
                        Button(action: { self.detailsVisible.toggle() }) {
                            Image(systemName: detailsVisible ? "eye.slash.fill" : "eye.fill")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 22.0, height: 22.0)
                                .foregroundColor(.walletPrimary)
                        }
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
            }
            .frame(height: 200)
            .cornerRadius(20)
            
            if (walletController.findProfile == nil) {
                Button(action: { showCreateProfileSheet.toggle() }) {
                    Text("Create Profile")
                    Spacer()
                    Image(systemName: "arrowshape.turn.up.right.circle")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22.0, height: 22.0)
                        .foregroundColor(.walletPrimary)
                }
                .frame(height: 25)
                .padding(10)
                .background(Color.lightBackground)
                .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
                .padding(.horizontal, 20)
                .sheet(isPresented: $showCreateProfileSheet) {
                    CreateFindProfile()
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                }
            }
        }
    }
}

struct DashboardCardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardCardView()
    }
}
