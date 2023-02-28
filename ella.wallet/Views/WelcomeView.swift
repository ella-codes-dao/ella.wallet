//
//  WelcomeView.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/22/23.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var walletController: WalletController
    @State var showAccountExistsAlert = false
    @State var proceedToCreateAccount = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.grey100
                    .edgesIgnoringSafeArea(.all)
                
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
                    
                    Image("logo-icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150)
                        .padding(.bottom, 20)
                    
                    Image("logo-text")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal, 30)
                    
                    Spacer()
                    
                    Button(action: { createWallet() }, label: {
                        Text("Create A New Wallet")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.black)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .padding(.vertical, 15)
                            .background(
                                Color.walletPrimary
                            )
                            .cornerRadius(20)
                    })
                    .padding(.top, 20)
                    .shadow(color: .white.opacity(0.25), radius: 8, y: 2)
                    
                    
                    Button {
                        
                    } label: {
                        Text("Link To Existing Wallet")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.black)
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
                            .foregroundColor(.black)
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
            .alert("Warning! \n\n An ella.wallet Account Key already exists in your iCloud Keychain. \n\n ella.wallet currently only supports one wallet per iCloud Account \n\n Proceeding to create a new wallet will override your current Account Key.", isPresented: $showAccountExistsAlert) {
                Button("Create Wallet", role: .destructive) { proceedToCreateAccount.toggle() }
                Button("Link Wallet", role: .cancel) { showAccountExistsAlert.toggle() }
            }
            .navigationDestination(isPresented: $proceedToCreateAccount) {
                CreateWallet()
            }
        }
    }
    
    func createWallet() {
        if walletController.accountInitiliazed {
            showAccountExistsAlert.toggle()
        } else {
            proceedToCreateAccount.toggle()
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
