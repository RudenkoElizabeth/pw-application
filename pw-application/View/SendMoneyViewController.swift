//
//  SendMoneyViewController.swift
//  pw-application
//
//  Created by Elizabeth Rudenko on 29.03.2018.
//  Copyright © 2018 Elizabeth Rudenko. All rights reserved.
//

import UIKit
import MBProgressHUD

class SendMoneyViewController: UIViewController {
    
    //UI elements
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var pwAmountTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    let viewModel = SendMoneyViewModel()
    public var nameRecipient = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        nameLable.text = nameRecipient
        //keyboard type
        pwAmountTextField.keyboardType = UIKeyboardType.numberPad
    }
    
    @IBAction func sendButtonTapped() {
        //wait for response
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let amount = pwAmountTextField.text ?? "0"
        viewModel.createTransactionBy(name: nameRecipient, andAmount: Int(amount)!)
    }
    
    public func succeessAlert() {
        //create the alert controller
        let alertController = UIAlertController(title: "", message: "Traisaction completed", preferredStyle: .alert)
        //create the action
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.navigationController?.popToRootViewController(animated: true)
        }
        //add the action
        alertController.addAction(okAction)
        //present the controller
        self.present(alertController, animated: true, completion: nil)
    }
}

extension SendMoneyViewController: SendMoneyViewModelDelegate {
    func sended() {
        MBProgressHUD.hide(for: self.view, animated: true)
        self.succeessAlert()
    }
    
    func error(_ errorText: String) {
        MBProgressHUD.hide(for: self.view, animated: true)
        AlertHelper().messageAlert(stringMessage: errorText, vc: self)
    }
}

