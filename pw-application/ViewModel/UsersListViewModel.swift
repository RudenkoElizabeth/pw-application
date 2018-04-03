//
//  UsersListViewModel.swift
//  pw-application
//
//  Created by Elizabeth Rudenko on 02.04.2018.
//  Copyright © 2018 Elizabeth Rudenko. All rights reserved.
//

import Foundation

protocol UsersListViewModelDelegate {
    func usersList(_ usersArray: [String])
    func error(_ errorText: String)
}

class UsersListViewModel:NSObject {
    
    let usersListNetworkService = UsersListNetworkService()
    var delegate: UsersListViewModelDelegate?
    
    override init() {
        super.init()
        usersListNetworkService.delegate = self
    }
    
    func getUsersListBy(name: String) {
        if name.count > 0 {
            usersListNetworkService.getFilteredUserList(filter: name)
        }
    }
}

extension UsersListViewModel: UsersListDelegate {
    func error(_ errorText: String) {
        delegate?.error(errorText)
    }
    
    func getUsersList(_ usersArray: [String]) {
        delegate?.usersList(usersArray)
    }
}
