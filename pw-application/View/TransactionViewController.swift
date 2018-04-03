//
//  TransactionViewController.swift
//  pw-application
//
//  Created by Elizabeth Rudenko on 29.03.2018.
//  Copyright © 2018 Elizabeth Rudenko. All rights reserved.
//

import UIKit
import MBProgressHUD

class TransactionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    //UI elements
    @IBOutlet weak var transactionTable: UITableView!
    @IBOutlet weak var userSortButton: UIButton!
    @IBOutlet weak var valueSortButton: UIButton!
    @IBOutlet weak var dateSortButton: UIButton!
    @IBOutlet weak var findTextField: UITextField!
    
    let viewModel = TransactionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        //add action to text field
        findTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        //clear table footer
        self.transactionTable.tableFooterView = UIView.init()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell") as! TransactionTableViewCell
        //set data
        if let cellData = viewModel.getCellDataByIndexPath(indexPath: indexPath) {
            cell.correspondentNameLabel.text = cellData.username
            cell.transactionAmountLabel.text = cellData.amount
            cell.resultingBalanceLabel.text = cellData.balance
            cell.dataTimeLabel.text = cellData.date
            cell.reapeatButton.isHidden = cellData.isRepeatButtonHidden
        }
        cell.reapeatButton.tag = indexPath.row
        //sdd action to reapeat button
        cell.reapeatButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        return cell
    }
    
    //return button on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        findTextField.resignFirstResponder()
        return true
    }
    
    @objc func buttonAction(_ sender: UIButton) {
        viewModel.repeatTransaction(indexPath: IndexPath.init(row: sender.tag, section: 0))
    }
    
    @IBAction func sortingButtonTapped(_ sender: UIButton) {
        //sorting
        viewModel.changeSortType(toSortType: sender.tag)
        transactionTable.reloadData()
        //rename all sort buttons
        userSortButton.setTitle(viewModel.changeSortButtonTitle(buttonTag: 1), for: .normal)
        valueSortButton.setTitle(viewModel.changeSortButtonTitle(buttonTag: 2), for: .normal)
        dateSortButton.setTitle(viewModel.changeSortButtonTitle(buttonTag: 3), for: .normal)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        viewModel.fiterByUsername(filterValue: textField.text ?? "")
        transactionTable.reloadData()
    }
}


extension TransactionViewController: TransactionViewModelDelegate {
    func showAlert(_ alertText: String) {
        AlertHelper().messageAlert(stringMessage: alertText, vc: self)
    }
    
    func reloadTableView() {
        transactionTable.reloadData()
    }
}
