//
//  DashboardView.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/25/23.
//

import SwiftUI

struct DashboardView: View {
    @State var sendCryptoSheetPresented = false
    @State var receiveCryptoSheetPresented = false
    
    var body: some View {
        VStack {
            // Card View
            DashboardCardView()
            
            // Wallet Actions
            HStack {
                Button(action: { sendCryptoSheetPresented.toggle() }) {
                    Image(systemName: "arrow.up")
                        .imageScale(.large)
                        .frame(maxWidth: .infinity, maxHeight: 35)
                        .background(Color.lightBackground)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $sendCryptoSheetPresented) {
                    SendCryptoView(isOpen: $sendCryptoSheetPresented)
                        .padding(.top, 10)
                        .padding(.horizontal, 20)
                }
                
                Button(action: { receiveCryptoSheetPresented.toggle() }) {
                    Image(systemName: "arrow.down")
                        .imageScale(.large)
                        .frame(maxWidth: .infinity, maxHeight: 35)
                        .background(Color.lightBackground)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $receiveCryptoSheetPresented) {
                    Text("Receive Crypto View")
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 35)
            
            // Token List
            Section {
                HStack {
                    Text("3 Coins")
                    
                    Spacer()
                    
                    Button(action: { }) {
                        HStack {
                            Image("wallet")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 22.0, height: 22.0)
                                .foregroundColor(.walletPrimary)
                            
                            Text("BUY")
                        }
                    }
                    .padding(.vertical, 7)
                    .padding(.horizontal, 10)
                    .background(Color.lightBackground)
                    .cornerRadius(20)
                    
                    Button(action: { }) {
                        Image(systemName: "plus")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22.0, height: 22.0)
                            .foregroundColor(.walletPrimary)
                    }
                    .padding(7)
                    .background(Color.lightBackground)
                    .cornerRadius(20)
                }
                .padding(.horizontal, 20)
                
                List {
                    TokenBalanceCardView(token: FLOW, amount: 402582.589, value: 1.195123)
                    TokenBalanceCardView(token: FUSD, amount: 3945.982, value: 1.000000)
                    TokenBalanceCardView(token: USDC, amount: 200.003, value: 1.000000)
                }
                .listStyle(.plain)
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
