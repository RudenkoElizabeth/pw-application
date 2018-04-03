//
//  ProfileViewModel.swift
//  pw-application
//
//  Created by Elizabeth Rudenko on 02.04.2018.
//  Copyright © 2018 Elizabeth Rudenko. All rights reserved.
//

import Foundation

class ProfileViewModel: NSObject {
    
    let profileDatabaseService = ProfileDatabaseService()
    
    func getProfileData() -> (name: String, balance: String) {
       if let profileData = profileDatabaseService.getProfile() {
            return (profileData.name, String(profileData.balance))
        }
        return ("", "")
    }
    
    func clearDatabase() {
        //clean token
        Settings.IdToken = ""
        //clean database
        profileDatabaseService.clearProfile()
        TransactionsDatabaseService().clearTransactions()
    }
}
