//
//  ApiEndpoint.swift
//  pw-application
//
//  Created by Elizabeth Rudenko on 30.03.2018.
//  Copyright © 2018 Elizabeth Rudenko. All rights reserved.
//

import Foundation
import Moya

enum ApiEndpoint {
    case auth(email: String, password: String)
    case createUser(username: String, password: String, email: String)
    case getAccount()
    case getTransactions()
    case getUsersList(filter: String)
    case createTransaction(name: String, amount: Int)
}

extension ApiEndpoint: TargetType {
    var headers: [String : String]? {
        switch self {
        case .auth(email: _, password: _),
             .createUser(username: _, password: _, email: _):
            return nil
        default:
            return ["Authorization": Settings.IdToken]
        }
    }
    //path of requests
    var baseURL: URL { return URL(string: Settings.serverAddress)! }
    var path: String {
        switch self {
        case .auth(email: _, password: _):
            return "sessions/create"
        case .createUser(username: _, password: _, email: _):
            return "users"
        case .getAccount():
            return "api/protected/user-info"
        case .getTransactions():
            return "api/protected/transactions"
        case .getUsersList(filter: _):
            return "api/protected/users/list"
        case .createTransaction(name: _, amount: _):
            return "api/protected/transactions"
        }
    }
    
    //include parameters
    var task: Task {
        switch self {
        case .auth(let email, let password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
        case .createUser(let username, let password, let email):
            return .requestParameters(parameters: ["username": username, "password": password, "email": email], encoding: JSONEncoding.default)
        case .getUsersList(let filter):
            return .requestParameters(parameters: ["filter": filter], encoding: JSONEncoding.default)
        case .createTransaction(let name, let amount):
            return .requestParameters(parameters: ["name": name, "amount": amount], encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    //choose type of request
    var method: Moya.Method {
        switch self {
        case .getTransactions(), .getAccount():
            return .get
        default:
            return .post
        }
    }
    
    //for tests
    var sampleData: Data {
        return Data.init()
    }
    
    //params encoding type
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
