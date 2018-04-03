//
//  AuthViewModel.swift
//  pw-application
//
//  Created by Elizabeth Rudenko on 02.04.2018.
//  Copyright © 2018 Elizabeth Rudenko. All rights reserved.
//

import Foundation

protocol AuthViewModelDelegate {
    func succeessAuth()
    func errorAuth(_ errorText: String)
}

class AuthViewModel: NSObject {
    
    let authNetworkService = AuthNetworkService()
    let profileNetworkService = ProfileNetworkService()
    var delegate: AuthViewModelDelegate?
    
    override init() {
        super.init()
        authNetworkService.delegate = self
        profileNetworkService.delegate = self
    }
    
    func tryAuthBy(email: String, andPassword password: String) {
        let isDataValid = authNetworkService.isValidAuthFields(email: email, andPassword: password)
        if isDataValid.isValid {
            authNetworkService.authByEmail(email: email, andPassword: password)
        } else {
            if let text = isDataValid.errorText {
                delegate?.errorAuth(text)
            }
        }
    }    
}


extension AuthViewModel: AuthDelegate {
    func succeessAuth() {
        profileNetworkService.getProfile()
    }
    func errorAuth(_ errorText: String) {
        delegate?.errorAuth(errorText)
    }
}

extension AuthViewModel: ProfileDelegate {
    func succeessProfile() {
        delegate?.succeessAuth()
    }
    
    func errorProfile(_ errorText: String) {
        delegate?.errorAuth(errorText)
    }
}


