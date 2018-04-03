//
//  RegistrationViewController.swift
//  pw-application
//
//  Created by Elizabeth Rudenko on 29.03.2018.
//  Copyright © 2018 Elizabeth Rudenko. All rights reserved.
//

import UIKit
import MBProgressHUD

class RegistrationViewController: UIViewController, UITextFieldDelegate {

    //UI elements
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var registrationButton: UIButton!
    
    let viewModel = RegistrationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        //set keyboard type
        emailTextField.keyboardType = UIKeyboardType.emailAddress
    }
    
    //return button on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        repeatPasswordTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func createNewAcountButtonTapped() {
        guard let fullName = nameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let repeatPassword = repeatPasswordTextField.text
            else { return }
        //wait for response
        MBProgressHUD.showAdded(to: self.view, animated: true)
        viewModel.tryRegistrationBy(fullName: fullName, andEmail: email, andPassword: password, andRepeatPassword: repeatPassword)
    }
}

extension RegistrationViewController: RegistrationViewModelDelegate {
    func succeessRegistration() {
        MBProgressHUD.hide(for: self.view, animated: true)
        //open profile view controller
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setViewController()
    }
    
    func errorRegistration(_ errorText: String) {
        MBProgressHUD.hide(for: self.view, animated: true)
        AlertHelper().messageAlert(stringMessage: errorText, vc: self)
    }
}

