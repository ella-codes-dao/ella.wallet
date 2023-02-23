//
//  RecoveryPhraseView.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/22/23.
//

import SwiftUI

struct CreateWallet: View {
    @EnvironmentObject var walletController: WalletController
    @State private var checkConfirmation = false
    @State private var showConfirmationAlert = false
    @State private var alertConfirmation = false
    @State private var recoveryPassword = ""

    let rows = [
        GridItem(.flexible(minimum: 25)),
        GridItem(.flexible(minimum: 25)),
        GridItem(.flexible(minimum: 25)),
        GridItem(.flexible(minimum: 25)),
        GridItem(.flexible(minimum: 25)),
        GridItem(.flexible(minimum: 25)),
    ]
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Recovery Phrase & Password")
                .foregroundColor(.grey8)
                .font(.system(size: 25, weight: .bold, design: .rounded))
            
            Group {
                Text("WARNING: ANYONE WITH ACCESS TO THE BELOW RECOVERY PHRASE & PASSWORD WILL HAVE FULLY ACCESS TO YOUR WALLET")
                    .foregroundColor(.foregroundNegative)
                    .font(.system(size: 15, weight: .heavy, design: .rounded))
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                
                Text("1. Store the your recovery phrase in a secure location only you have access to.")
                    .foregroundColor(.foregroundNegative)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.top, 10)
                Text("2. Your recovery phrase should only be used to restore access to your wallet when no other aurhtoized devices are available")
                    .foregroundColor(.foregroundNegative)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.top, 10)
                Text("3. Do not lose or give anyone access to your Recovery Password - You cannot restore your wallet without it!")
                    .foregroundColor(.foregroundNegative)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.top, 10)
            }
            
            Spacer()
            
            LazyHGrid(rows: rows, alignment: .center) {
                ForEach(walletController.recoveryPhraseArray.indices, id: \.self) { i in
                    Text("\(i + 1): \(walletController.recoveryPhraseArray[i])")
                        .padding(.horizontal, 50)
                }
            }
            .background(Color.grey50)
            .cornerRadius(25)
            
            Spacer()
            
            TextField("Recovery Password", text: $recoveryPassword, prompt: Text("Enter Recovery Password"))
                .textFieldStyle(.roundedBorder)
            
            Spacer()
            
            Toggle("I have saved the above recovery phrase in a secure location.", isOn: $checkConfirmation)
                .toggleStyle(iOSCheckboxToggleStyle())
            
            Button(action: { showConfirmationAlert.toggle() }) {
                Text("Next")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .padding(.vertical, 15)
                    .background(
                        checkConfirmation && !recoveryPassword.isEmpty ? Color.walletPrimary : Color.grey50
                    )
                    .cornerRadius(20)
            }
            .padding(.top, 20)
            .shadow(color: .white.opacity(0.25), radius: 8, y: 2)
            .disabled(!checkConfirmation || recoveryPassword.isEmpty)
            .alert("Important - The Recovery Phrase WILL NOT be shown again, ensure you have saved it in a secure location before proceeding!", isPresented: $showConfirmationAlert) {
                Button("OK", role: .cancel) { createWallet() }
                Button("Go Back", role: .destructive) { checkConfirmation.toggle() }
            }
        }
        .padding(.horizontal, 10)
        .navigationDestination(isPresented: $alertConfirmation) {
            CreateWalletProgressView()
        }
        .onAppear() {
            walletController.createMnemonicPhrase()
        }
    }
    
    func createWallet() {
        walletController.createWallet(password: recoveryPassword)
        alertConfirmation.toggle()
    }

}

struct CreateWallet_Previews: PreviewProvider {
    static var previews: some View {
        CreateWallet()
    }
}
