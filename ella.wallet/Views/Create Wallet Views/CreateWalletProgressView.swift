//
//  CreateWalletProgressView.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/23/23.
//

import SwiftUI

struct CreateWalletProgressView: View {
    @EnvironmentObject var walletController: WalletController
    @Binding var IsOpen: Bool
    
    var body: some View {
        VStack {
            switch walletController.walletCreationPhase {
            case .generatingAccountAndDeviceKeys:
                Text("Creating Account Keys...")
            case .creatingFlowAccount:
                Text("Creating Account on Flow...")
            case .walletCreated:
                Text("Wallet Succesfully Created!").onAppear() {
                    IsOpen.toggle()
                }
            default:
                Text("Opps... Something went wrong, please go back and try again")
            }
            
            if walletController.walletCreationPhase == .notStarted || walletController.walletCreationPhase == .error {
                Image(systemName: "exclamationmark.triangle.fill")
                    .renderingMode(.original)
            } else {
                ProgressView()
            }
        }
    }
}
