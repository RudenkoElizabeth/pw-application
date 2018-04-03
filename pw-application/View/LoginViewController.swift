//
//  LoginViewController.swift
//  pw-application
//
//  Created by Elizabeth Rudenko on 29.03.2018.
//  Copyright © 2018 Elizabeth Rudenko. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //UI elements
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    
    let viewModel = AuthViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        //set keyboard type
        emailTextField.keyboardType = UIKeyboardType.emailAddress
    }
    
    //return button on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func loginButtonTapped() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        //wait for response
        MBProgressHUD.showAdded(to: self.view, animated: true)
        viewModel.tryAuthBy(email: email, andPassword: password)
    }
}


extension LoginViewController: AuthViewModelDelegate {
    func succeessAuth() {
        MBProgressHUD.hide(for: self.view, animated: true)
        //open profile view controller
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setViewController()
    }
    
    func errorAuth(_ errorText: String) {
        MBProgressHUD.hide(for: self.view, animated: true)
        AlertHelper().messageAlert(stringMessage: errorText, vc: self)
    }
}
