//
//  AlertHelper.swift
//  pw-application
//
//  Created by Elizabeth Rudenko on 31.03.2018.
//  Copyright © 2018 Elizabeth Rudenko. All rights reserved.
//

import Foundation
import UIKit

class AlertHelper {

    public func messageAlert(stringMessage: String, vc: UIViewController) {
         //create the alert controller
        let alert = UIAlertController(title: "", message: stringMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        //present the controller
        vc.present(alert, animated: true, completion: nil)
    }
}
