//
//  RecipientViewController.swift
//  pw-application
//
//  Created by Elizabeth Rudenko on 29.03.2018.
//  Copyright © 2018 Elizabeth Rudenko. All rights reserved.
//

import UIKit

class RecipientViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate  {
    
    //UI elements
    @IBOutlet weak var nameTable: UITableView!
    @IBOutlet weak var findTextField: UITextField!
    
    let viewModel = UsersListViewModel()
    var filteredUserArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        findTextField.delegate = self
        //Footer for table
        self.nameTable.tableFooterView = UIView.init()
        //action for find text field
        findTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUserArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipientTableViewCell") as! RecipientTableViewCell
        //contain cell
        cell.correspondentNameLabel.text = filteredUserArray[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //open send money view controller
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SendMoneyViewController") as! SendMoneyViewController
        nextVC.nameRecipient = filteredUserArray[indexPath.item]
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = findTextField.text ?? ""
        viewModel.getUsersListBy(name: text)
    }
    
    //return button on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        findTextField.resignFirstResponder()
        return true
    }
}

extension RecipientViewController: UsersListViewModelDelegate {
    func usersList(_ usersArray: [String]) {
        filteredUserArray = usersArray
        nameTable.reloadData()
    }
    
    func error(_ errorText: String) {
        AlertHelper().messageAlert(stringMessage: errorText, vc: self)
    }    
}


