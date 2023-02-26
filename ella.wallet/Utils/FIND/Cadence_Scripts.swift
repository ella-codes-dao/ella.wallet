//
//  Script.swift
//  FLOATs
//
//  Created by BoiseITGuru on 7/16/22.
//

import Foundation

enum FindScripts: String {
    case reverseLookupFIND =
        """
        import FIND, Profile from 0x35717efbbce11c74

        pub fun main(address: Address) :  String? {
            return FIND.reverseLookup(address)
        }
        """
    case reverseLookupProfile =
        """
        import Profile from 0x35717efbbce11c74

        pub fun main(address: Address) :  Profile.UserProfile? {
            return getAccount(address)
                .getCapability<&{Profile.Public}>(Profile.publicPath)
                .borrow()?.asProfile()
        }
        """
}
