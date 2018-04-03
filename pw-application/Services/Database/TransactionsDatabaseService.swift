//
//  TransactionsRealmViewModel.swift
//  pw-application
//
//  Created by Elizabeth Rudenko on 31.03.2018.
//  Copyright © 2018 Elizabeth Rudenko. All rights reserved.
//

import RealmSwift

class TransactionsDatabaseService: NSObject {
    
    let databaseService = DatabaseService()
    //array of list transactions
    var transactionsArray: [DataTransactionsRealmModel]?
    
    override init() {
        super.init()
        //intitial sorting by date
        sortTransactionsBy(keyPath: "date", ascending: false, filterField: nil, filterValue: nil)
    }
    
    
    func sortTransactionsBy(keyPath: String, ascending: Bool, filterField: String?, filterValue: String?) {
        if (filterField != nil && filterValue != nil && filterValue?.count ?? 0 > 0) {
            let predicate = NSPredicate.init(format: ("\(filterField!) CONTAINS[cd] '\(filterValue!)'"), argumentArray: nil)
            transactionsArray = databaseService.getObjects(type: DataTransactionsRealmModel.self, sortedByKeyPath: keyPath, ascending: ascending,  predicate: predicate) as? [DataTransactionsRealmModel]
        } else {
            transactionsArray = databaseService.getObjects(type: DataTransactionsRealmModel.self, sortedByKeyPath: keyPath, ascending: ascending) as? [DataTransactionsRealmModel]
        }
    }
    
    func saveTransaction(id: Int, date: String, username: String, amount: Int, balance: Int) {
        let transaction = DataTransactionsRealmModel()
        transaction.id = id
        transaction.date = date
        transaction.username = username
        transaction.amount = amount
        transaction.balance = balance
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(transaction)
        }
    }
    
    func countTransactions() -> Int {
        return transactionsArray?.count ?? 0
    }
    
    func clearTransactions() {
        transactionsArray = nil
        var config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
        let realm = try! Realm(configuration: config)
        let results = realm.objects(DataTransactionsRealmModel.self)
        try! realm.write {
            realm.delete(results)
        }
    }
}

