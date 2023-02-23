//
//  WelcomeView.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/22/23.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var walletController: WalletController
    
    var body: some View {
        ZStack {
            Color.grey100
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                Text("Welcome")
                    .foregroundColor(.grey8)
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                
                Text("A crypto wallet on Flow built for DAO members, businesses, and security minded users.")
                    .foregroundColor(.grey50)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.top, 10)
                
                Spacer()
                
                NavigationLink(destination: CreateWallet()) {
                    Text("Create A New Wallet")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .padding(.vertical, 15)
                        .background(
                            Color.walletPrimary
                        )
                        .cornerRadius(20)
                }
                .padding(.top, 20)
                .shadow(color: .white.opacity(0.25), radius: 8, y: 2)
                
                
                Button {
                    
                } label: {
                    Text("Link To Existing Wallet")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .padding(.vertical, 15)
                        .background(
                            Color.walletPrimary
                        )
                        .cornerRadius(20)
                }
                .padding(.top, 20)
                .shadow(color: .white.opacity(0.25), radius: 8, y: 2)
                
                Button(action: { }) {
                    Text("Recover Wallet")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .padding(.vertical, 15)
                        .background(
                            Color.walletPrimary
                        )
                        .cornerRadius(20)
                }
                .padding(.top, 20)
                .shadow(color: .white.opacity(0.25), radius: 8, y: 2)
            }
            .padding([.horizontal, .vertical], 20)
            .padding(.top, 20)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
