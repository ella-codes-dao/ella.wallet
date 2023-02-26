//
//  CreateFindProfile.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/25/23.
//

import SwiftUI
import Flow

struct CreateFindProfile: View {
    @EnvironmentObject var walletController: WalletController
    
    @State private var profileName = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Choose a .find profile name!")
                .foregroundColor(.grey8)
                .font(.system(size: 34, weight: .bold, design: .rounded))
            
            Text("A profile name gives you a way to identify your profile on .find and other platforms, while a .find name provides an identity for your 18 digit '0x...' wallet address.\n\nTo find out more about .find names or to register one for your wallet visit the settings tab.")
                .foregroundColor(.grey50)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .padding(.top, 10)
                .padding(.bottom, 30)
            
            TextField("Profile Name", text: $profileName, prompt: Text("Enter Profile Name"))
                .textFieldStyle(.roundedBorder)
            
            Spacer()
            
            Button(action: { createProfile() }) {
                Text("Create Profile")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .padding(.vertical, 15)
                    .background(
                        !profileName.isEmpty ? Color.walletPrimary : Color.grey50
                    )
                    .cornerRadius(20)
            }
            .padding(.horizontal, 20)
            .shadow(color: .white.opacity(0.25), radius: 8, y: 2)
            .disabled(profileName.isEmpty)
        }
    }
    
    func createProfile() {
        Task {
            do {
                let arguments: [Flow.Argument] = [.init(type: .string, value: .string(self.profileName))]
                try await walletController.executeFlowTx(transaction: FindTransactions.createProfile.rawValue, flowArguments: arguments)
            } catch {
                print(error)
            }
        }
    }
}

struct CreateFindProfile_Previews: PreviewProvider {
    static var previews: some View {
        CreateFindProfile()
    }
}
