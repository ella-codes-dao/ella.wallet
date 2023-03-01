//
//  File.swift
//  ella.wallet
//
//  Created by BoiseITGuru on 2/28/23.
//

import UIKit
import IceCream
import RealmSwift

class MyAppDelegate: UIResponder, UIApplicationDelegate {
    var syncEngine: SyncEngine?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        syncEngine = SyncEngine(objects: [
                SyncObject(type: WalletGroup.self, uListElementType: Wallet.self),
                SyncObject(type: Wallet.self, uListElementType: Device.self),
                SyncObject(type: Device.self)
            ])
        application.registerForRemoteNotifications()
        
        let realm = try? Realm()
        try? realm?.write {
            
        }
        
        return true
    }
}
