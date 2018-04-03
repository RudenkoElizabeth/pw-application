//
//  SendMoneyViewModel.swift
//  pw-application
//
//  Created by Elizabeth Rudenko on 02.04.2018.
//  Copyright © 2018 Elizabeth Rudenko. All rights reserved.
//

import Foundation

protocol SendMoneyViewModelDelegate {
    func sended()
    func error(_ errorText: String)
}

class SendMoneyViewModel: NSObject {
    
    let transactionsNetworkService = TransactionsNetworkService()
    let profileNetworkService = ProfileNetworkService()
    var delegate: SendMoneyViewModelDelegate?
    
    override init() {
        super.init()
        transactionsNetworkService.createTransactionDelegate = self
        profileNetworkService.delegate = self
    }
    
    func createTransactionBy(name: String, andAmount amount: Int) {
        if amount > 0 {
            transactionsNetworkService.createTransaction(username: name, andAmount: amount)
        } else {
            delegate?.error("Fill in the field")
        }
    }
}

extension SendMoneyViewModel: CreateTransactionDelegate {
    func succeessTransaction() {
        ProfileDatabaseService().clearProfile()
        profileNetworkService.getProfile()
    }
    
    func errorTransaction(_ errorText: String) {
        delegate?.error(errorText)
    }
}

extension SendMoneyViewModel: ProfileDelegate {
    func succeessProfile() {
        delegate?.sended()
    }
    
    func errorProfile(_ errorText: String) {
        delegate?.error(errorText)
    }
}
