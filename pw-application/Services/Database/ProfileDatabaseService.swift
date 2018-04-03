//
//  ProfileRealmViewModel.swift
//  pw-application
//
//  Created by Elizabeth Rudenko on 31.03.2018.
//  Copyright © 2018 Elizabeth Rudenko. All rights reserved.
//

import RealmSwift

class ProfileDatabaseService: NSObject {
    
    func saveProfile(id: Int, name: String, email: String, balance: Int) {
        let profile = ProfileRealmModel()
        profile.id = id
        profile.name = name
        profile.email = email
        profile.balance = balance
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(profile)
        }
    }
    
    func getProfile() -> ProfileRealmModel? {
        var config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
        let realm = try! Realm(configuration: config)
        let results = realm.objects(ProfileRealmModel.self)
        if results.count > 0 {
            return results[0]
        } else {
            return nil
        }
    }
    
    func clearProfile() {
        var config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
        let realm = try! Realm(configuration: config)
        let injections = realm.objects(ProfileRealmModel.self)
        try! realm.write {
            realm.delete(injections)
        }
    }
}

