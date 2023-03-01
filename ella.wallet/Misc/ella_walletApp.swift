//
//  ella_walletApp.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/22/23.
//

import SwiftUI

@main
struct ella_walletApp: App {
    @StateObject var walletController = WalletController()
    
    @UIApplicationDelegateAdaptor(MyAppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RouterView().environmentObject(walletController).preferredColorScheme(.dark)
        }
    }
}
