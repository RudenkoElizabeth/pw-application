//
//  RealmModels.swift
//  pw-application
//
//  Created by Elizabeth Rudenko on 31.03.2018.
//  Copyright © 2018 Elizabeth Rudenko. All rights reserved.
//

import RealmSwift

class ProfileRealmModel: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var email = ""
    @objc dynamic var balance = 0
}

class DataTransactionsRealmModel: Object {
    @objc dynamic var id = 0
    @objc dynamic var date = ""
    @objc dynamic var username = ""
    @objc dynamic var amount = 0
    @objc dynamic var balance = 0
}
