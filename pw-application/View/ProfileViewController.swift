//
//  ViewController.swift
//  pw-application
//
//  Created by Elizabeth Rudenko on 29.03.2018.
//  Copyright © 2018 Elizabeth Rudenko. All rights reserved.
//

import UIKit
import MBProgressHUD

class ProfileViewController: UIViewController {
    
    //UI elements
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pwBalanceLabel: UILabel!
    @IBOutlet weak var newTransactionButton: UIButton!
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    let transactionsViewModel = TransactionsNetworkService()
    let viewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transactionsViewModel.transactionsListDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //show profile information
        let profile = viewModel.getProfileData()
        nameLabel.text = profile.name
        pwBalanceLabel.text = profile.balance
    }
    
    @IBAction func logOutButtonTapped() {
        //clear all saved data
        viewModel.clearDatabase()
        //open login view controller
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setViewController()
    }
    
    @IBAction func transactionsButtonTapped() {
        //wait for response
        TransactionsDatabaseService().clearTransactions()
        transactionsViewModel.getTransactionsList()
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
}

extension ProfileViewController: TransactionsListDelegate {
    func succeessTransactions() {
        MBProgressHUD.hide(for: self.view, animated: true)
        //open transactions view controller
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "TransactionViewController") as! TransactionViewController
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func errorTransactions(_ errorText: String) {
        MBProgressHUD.hide(for: self.view, animated: true)
        AlertHelper().messageAlert(stringMessage: errorText, vc: self)
    }
}
