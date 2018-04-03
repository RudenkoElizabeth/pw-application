//
//  AppDelegate.swift
//  pw-application
//
//  Created by Elizabeth Rudenko on 29.03.2018.
//  Copyright © 2018 Elizabeth Rudenko. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        TransactionsDatabaseService().clearTransactions()
        ProfileDatabaseService().clearProfile()
        return true
    }

     func setViewController() {
        if Settings.IdToken == "" {
            if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                self.window?.rootViewController = controller
            }
        } else {
            if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as? ProfileViewController {
                self.window?.rootViewController = UINavigationController.init(rootViewController: controller)
            }
        }
    }
}

