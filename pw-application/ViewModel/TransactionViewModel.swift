//
//  TransactionViewModel.swift
//  pw-application
//
//  Created by Elizabeth Rudenko on 01.04.2018.
//  Copyright © 2018 Elizabeth Rudenko. All rights reserved.
//

import Foundation

protocol TransactionViewModelDelegate: class {
    func showAlert(_ alertText: String)
    func reloadTableView()
}

class TransactionViewModel: NSObject {
    
    let transactionsDatabaseService = TransactionsDatabaseService()
    let transactionsNetworkService = TransactionsNetworkService()
    weak var delegate: TransactionViewModelDelegate?
    var isAscending = false
    var sortType = 3
    var filterValue = ""
    
    override init() {
        super.init()
        transactionsNetworkService.createTransactionDelegate = self
        transactionsNetworkService.transactionsListDelegate = self
    }
    
    func numberOfRows() -> Int {
        return transactionsDatabaseService.countTransactions()
    }
    
    func getCellDataByIndexPath(indexPath: IndexPath) -> (username: String, amount: String, balance: String, date: String, isRepeatButtonHidden: Bool)? {
        if let transaction = transactionsDatabaseService.transactionsArray?[indexPath.row] {
            var isRepeatButtonHidden = false
            if transaction.amount > 0 {
                isRepeatButtonHidden = true
            }
            return (transaction.username,
                    "Transaction amount: \(transaction.amount) PW",
                "Resulting balance: \(transaction.balance) PW",
                transaction.date,
                isRepeatButtonHidden)
        }
        return nil
    }
    
    func repeatTransaction(indexPath: IndexPath) {
        if let transaction = transactionsDatabaseService.transactionsArray?[indexPath.row] {
            transactionsNetworkService.createTransaction(username: transaction.username, andAmount: -1 * transaction.amount)
        }
    }
    
    func changeSortType(toSortType newSortType: Int) {
        if (sortType == newSortType) {
            isAscending = !isAscending
        }
        sortType = newSortType
        var keyPath = ""
        switch sortType {
        case 1: keyPath = "username"
        case 2: keyPath = "amount"
        default: keyPath = "date"
        }
        transactionsDatabaseService.sortTransactionsBy(keyPath: keyPath, ascending: isAscending, filterField: "username", filterValue: nil)
    }
    
    func fiterByUsername(filterValue: String) {
        self.filterValue = filterValue
        var keyPath = ""
        switch sortType {
        case 1: keyPath = "username"
        case 2: keyPath = "amount"
        default: keyPath = "date"
        }
        transactionsDatabaseService.sortTransactionsBy(keyPath: keyPath, ascending: isAscending, filterField: "username", filterValue: filterValue)
    }
    
    func changeSortButtonTitle(buttonTag: Int) -> String {
        var title = ""
        switch buttonTag {
        case 1: title = "User"
        case 2: title = "Value"
        default: title = "Date"
        }
        //add char to title
        if buttonTag == sortType {
            if isAscending {
                title = "▲ \(title)"
            } else {
                title = "▼ \(title)"
            }
        }
        return title
    }
}

extension TransactionViewModel: CreateTransactionDelegate {
    func succeessTransaction() {
        delegate?.showAlert("Trainsaction completed")
        transactionsDatabaseService.clearTransactions()
        transactionsNetworkService.getTransactionsList()
        ProfileDatabaseService().clearProfile()
        ProfileNetworkService().getProfile()
    }
    
    func errorTransaction(_ errorText: String) {
        delegate?.showAlert(errorText)
    }
}

extension TransactionViewModel: TransactionsListDelegate {
    func succeessTransactions() {
        transactionsDatabaseService.sortTransactionsBy(keyPath: "date", ascending: isAscending, filterField: nil, filterValue: nil)
        delegate?.reloadTableView()
    }
    
    func errorTransactions(_ errorText: String) {
        delegate?.showAlert(errorText)
    }
}
