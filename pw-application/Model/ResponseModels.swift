//
//  AccountResponseModel.swift
//  pw-application
//
//  Created by Elizabeth Rudenko on 30.03.2018.
//  Copyright © 2018 Elizabeth Rudenko. All rights reserved.
//

import Foundation

struct AuthResponseModel: Decodable {
    let id_token: String?
}

struct AccountResponseModel: Decodable {
    let user_info_token: AccountModel?
}

struct AccountModel: Decodable {
    let id: Int?
    let name: String?
    let email: String?
    let balance: Int?
}

struct TransactionResponseModel: Decodable {
    let trans_token: TransactionModel?
}

struct TransactionModel: Decodable {
    let id: Int?
    let date: String?
    let username: String?
    let amount: Int?
    let balance: Int?
}

struct UserTransactionsResponseModel: Decodable {
    let trans_token: [TransactionModel]?
}

struct FiltredUsersResponseModel: Decodable {
    let userArray: [UserModel]?
}

struct UserModel: Decodable {
    let id: Int?
    let name: String?
}
