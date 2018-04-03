//
//  DatabaseService.swift
//  pw-application
//
//  Created by Elizabeth Rudenko on 01.04.2018.
//  Copyright © 2018 Elizabeth Rudenko. All rights reserved.
//

import RealmSwift

class DatabaseService: NSObject {

    func getObjects(type: Object.Type, sortedByKeyPath keyPath: String, ascending: Bool) -> [Object]? {
        do {
            let realm = try Realm()
            let results = realm.objects(type).sorted(byKeyPath: keyPath, ascending: ascending)
            return Array(results)
        } catch {
            return nil
        }
    }
    
    func getObjects(type: Object.Type, sortedByKeyPath keyPath: String, ascending: Bool, predicate: NSPredicate) -> [Object]? {
        do {
            let realm = try Realm()
            let results = realm.objects(type).filter(predicate).sorted(byKeyPath: keyPath, ascending: ascending)
            return Array(results)
        } catch {
            return nil
        }
    }
}

