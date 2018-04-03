//
//  AuthRequest.swift
//  pw-application
//
//  Created by Elizabeth Rudenko on 30.03.2018.
//  Copyright © 2018 Elizabeth Rudenko. All rights reserved.
//

import Foundation
import Moya

protocol AuthDelegate  {
    func succeessAuth()
    func errorAuth(_ errorText: String)
}


class AuthNetworkService: NSObject {

    var delegate: AuthDelegate?
    let text = "Something went wrong\nTry again later"
    
    func authByEmail(email: String, andPassword password: String) {
        
        let apiProvider = MoyaProvider<ApiEndpoint>()
        
        apiProvider.request(ApiEndpoint.auth(email: email, password: password)) { (result) in
            switch result {
            case let .success(response):                
                switch response.responseClass {
                case .success:
                    self.successAuth(response: response)
                default:
                    print("Unexpected error: \(response)")
                    self.delegate?.errorAuth("Invalid email or password")
                }
            case let .failure(error):
                print("Request error: \(error)")
                self.delegate?.errorAuth(self.text)
            }
        }
    }
    
    func createNewAccount(fullName: String, andEmail email: String, andPassword password: String) {

        let apiProvider = MoyaProvider<ApiEndpoint>()
        
        apiProvider.request(ApiEndpoint.createUser(username: fullName, password: password, email: email)) { (result) in
            switch result {
            case let .success(response):
                switch response.responseClass {
                case .success:
                    self.successAuth(response: response)
                default:
                    print("Unexpected error: \(response)")
                    self.delegate?.errorAuth("A user with that email already exists")
                }
            case let .failure(error):
                print("Request error: \(error)")
                self.delegate?.errorAuth("Request error: \(error)")
            }
        }
    }
    
    // Mapping of token
    private func successAuth(response: Response) {
        do {
            if let token = try response.map(AuthResponseModel.self).id_token {
                Settings.IdToken = "Bearer \(token)"
                delegate?.succeessAuth()
            }
        } catch {
            print("Unexpected error: \(error)")
            delegate?.errorAuth(text)
        }
    }
        
    //Check auth filled fields
    func isValidAuthFields(email: String, andPassword password: String) -> (isValid: Bool, errorText: String?) {
        if email.count == 0 || password.count == 0 {
            return (false, "You must send username and password")
        } else {
            if !isValidEmail(emailStr: email) {
                return (false, "The e-mail you entered is not valid\nPlease try again")
            }
        }
        return (true, nil)
    }
    
    //Check filled fields when create a new account
    func isValidAccountFields(fullName: String, andEmail email: String, andPassword password: String, andRepeatPassword repeatePassword: String) -> (isValid: Bool, errorText: String?) {
        if fullName.count == 0 || email.count == 0 || password.count == 0 || repeatePassword.count == 0 {
            return (false, "You must fill all the fields")
        } else {
            if !isValidEmail(emailStr: email) {
                return (false, "The e-mail you entered is not valid\nPlease try again")
            }
            if password != repeatePassword {
                return (false, "The password and confirm password fields do not match\nPlease try again")
            }
        }
        return (true, nil)
    }
    
    //Check email
    private func isValidEmail(emailStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailStr)
    }
}

