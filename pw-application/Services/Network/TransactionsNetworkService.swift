//
//  TransactionsNetworkService.swift
//  pw-application
//
//  Created by Elizabeth Rudenko on 31.03.2018.
//  Copyright © 2018 Elizabeth Rudenko. All rights reserved.
//

import Foundation
import Moya

protocol TransactionsListDelegate {
    func succeessTransactions()
    func errorTransactions(_ errorText: String)
}

protocol CreateTransactionDelegate {
    func succeessTransaction()
    func errorTransaction(_ errorText: String)
}

class TransactionsNetworkService: NSObject {
    
    var transactionsListDelegate: TransactionsListDelegate?
    var createTransactionDelegate: CreateTransactionDelegate?
    
    let text = "Something went wrong\nTry again later"
    
    func getTransactionsList() {
        let apiProvider = MoyaProvider<ApiEndpoint>()
        
        apiProvider.request(ApiEndpoint.getTransactions()) { (result) in
            switch result {
            case let .success(response):
                switch response.responseClass {
                case .success:
                    self.mapTransactionsList(response: response)
                default:
                    print("Unexpected error: \(response)")
                    self.transactionsListDelegate?.errorTransactions(self.text)
                }
            case let .failure(error):
                print("Request error: \(error)")
                self.transactionsListDelegate?.errorTransactions(self.text)
            }
        }
    }
    
    
    
    func createTransaction(username: String, andAmount amount: Int) {
        let apiProvider = MoyaProvider<ApiEndpoint>()
        
        apiProvider.request(ApiEndpoint.createTransaction(name: username, amount: amount)) { (result) in
            switch result {
            case let .success(response):
                switch response.responseClass {
                case .success:
                    self.createTransactionDelegate?.succeessTransaction()
                default:
                    print("Unexpected error: \(response)")
                    self.createTransactionDelegate?.errorTransaction("Balance exceeded")
                }
            case let .failure(error):
                print("Request error: \(error)")
                self.createTransactionDelegate?.errorTransaction(self.text)
            }
        }
    }
    
}

// Mapping of data
extension TransactionsNetworkService {
    
    private func mapTransactionsList(response: Response) {
        do {
            if let arrayOfTransactions = try response.map(UserTransactionsResponseModel.self).trans_token {
                for dataTransaction in arrayOfTransactions {
                    guard let idUser = dataTransaction.id,
                        let dateTransaction = dataTransaction.date,
                        let usernameTransaction = dataTransaction.username,
                        let amountTransaction = dataTransaction.amount,
                        let balanceUser = dataTransaction.balance
                        else { print ("error")
                            return }
                    TransactionsDatabaseService().saveTransaction(id: idUser, date: dateTransaction, username: usernameTransaction, amount: amountTransaction, balance: balanceUser)
                }
                transactionsListDelegate?.succeessTransactions()
            }
        } catch {
            print("Unexpected error: \(error)")
        }
    }
}
