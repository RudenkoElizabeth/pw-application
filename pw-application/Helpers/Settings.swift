//
//  TokenSource.swift
//  pw-application
//
//  Created by Elizabeth Rudenko on 30.03.2018.
//  Copyright © 2018 Elizabeth Rudenko. All rights reserved.
//

import Foundation

class Settings: NSObject {
    
    public static let serverAddress = "http://193.124.114.46:3001/"
    
    public static var IdToken: String {
        get {
           return UserDefaults.standard.string(forKey: "id_token") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "id_token")
        }
    }
}
