//
//  RegistrationViewModel.swift
//  pw-application
//
//  Created by Elizabeth Rudenko on 02.04.2018.
//  Copyright © 2018 Elizabeth Rudenko. All rights reserved.
//

import Foundation

protocol RegistrationViewModelDelegate {
    func succeessRegistration()
    func errorRegistration(_ errorText: String)
}

class RegistrationViewModel: NSObject {
    
    let authNetworkService = AuthNetworkService()
    let profileNetworkService = ProfileNetworkService()
    var delegate: RegistrationViewModelDelegate?
    
    override init() {
        super.init()
        authNetworkService.delegate = self
        profileNetworkService.delegate = self
    }
    
    func tryRegistrationBy(fullName: String, andEmail email: String, andPassword password: String, andRepeatPassword repeatePassword: String) {
        let isAccountDataValid = authNetworkService.isValidAccountFields(fullName: fullName, andEmail: email, andPassword: password, andRepeatPassword: repeatePassword)
        if isAccountDataValid.isValid {
            authNetworkService.createNewAccount(fullName: fullName, andEmail: email, andPassword: password)
        } else {
            if let textError = isAccountDataValid.errorText {
                delegate?.errorRegistration(textError)
            }
        }
    }
}

extension RegistrationViewModel: AuthDelegate {
    func succeessAuth() {
        profileNetworkService.getProfile()
    }
    func errorAuth(_ errorText: String) {
        delegate?.errorRegistration(errorText)
    }
}

extension RegistrationViewModel: ProfileDelegate {
    func succeessProfile() {
        delegate?.succeessRegistration()
    }
    
    func errorProfile(_ errorText: String) {
        delegate?.errorRegistration(errorText)
    }
}

