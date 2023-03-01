//
//  IntegratedDappDetailsView.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/28/23.
//

import SwiftUI

struct IntegratedDappDetailsView: View {
    @EnvironmentObject var walletController: WalletController
    
    @State var name: String
    @State var desc: String
    @State var image: String
    @Binding var isOpen: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: { isOpen.toggle() }, label: {
                Image(systemName: "arrow.left")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
            })
                .frame(width: 22.0, height: 22.0)
                .padding(.vertical, 15)
            
            VStack(alignment: .center) {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 180, height: 180)
                
                Text(name)
                    .font(.title3)
                    .padding(.bottom, 10)
                
                Text(desc)
                    .font(.subheadline)
                
                Spacer()
                
                Button(action: { walletController.selectedDAPP = selectedDAPP(rawValue: name) ?? .none }) {
                    Text("Launch \(name)")
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
        }
        .padding(.horizontal, 30)
    }
}
