//
//  UsersListDelegate.swift
//  pw-application
//
//  Created by Elizabeth Rudenko on 01.04.2018.
//  Copyright © 2018 Elizabeth Rudenko. All rights reserved.
//

import Foundation
import Moya

protocol UsersListDelegate {
    func getUsersList(_ usersArray:[String])
    func error(_ errorText: String)
}

class UsersListNetworkService: NSObject {
    
    var delegate: UsersListDelegate?
    let text = "Something went wrong\nTry again later"
    
    func getFilteredUserList(filter: String) {
        
        let apiProvider = MoyaProvider<ApiEndpoint>()
        apiProvider.request(ApiEndpoint.getUsersList(filter: filter)) { (result) in
            switch result {
            case let .success(response):
                switch response.responseClass {
                case .success:
                    self.receivedData(response: response)
                default:
                    print("Unexpected error: \(response)")
                    self.delegate?.error(self.text)
                }
            case let .failure(error):
                print("Request error: \(error)")
                self.delegate?.error(self.text)
            }
        }
    }
    
    // Mapping of data
    private func receivedData(response: Response) {
        do {
            var filteredUsers = [String]()
            if let arrayOfUsers = try response.map([UserModel]?.self) {
                for user in arrayOfUsers {
                    filteredUsers.append(user.name ?? "")
                }
            }
            else {
                self.delegate?.error(self.text)
                return
            }
            delegate?.getUsersList(filteredUsers)
        } catch {
            print("Unexpected error: \(error)")
            self.delegate?.error(self.text)
        }
    }
}

