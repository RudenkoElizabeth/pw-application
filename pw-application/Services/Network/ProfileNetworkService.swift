//
//  ProfileViewModel.swift
//  pw-application
//
//  Created by Elizabeth Rudenko on 31.03.2018.
//  Copyright © 2018 Elizabeth Rudenko. All rights reserved.
//

import Foundation
import Moya

protocol ProfileDelegate {
    func succeessProfile()
    func errorProfile(_ errorText: String)
}

class ProfileNetworkService: NSObject {
    
    var delegate: ProfileDelegate?
    let text = "Something went wrong\nTry again later"
    
    func getProfile() {
        let apiProvider = MoyaProvider<ApiEndpoint>()
        
        apiProvider.request(ApiEndpoint.getAccount()) { (result) in
            switch result {
            case let .success(response):
                switch response.responseClass {
                case .success:
                    self.receivedData(response: response)
                default:
                    print("Unexpected error: \(response)")
                    self.delegate?.errorProfile(self.text)
                }
            case let .failure(error):
                print("Request error: \(error)")
                self.delegate?.errorProfile(self.text)
            }
        }
    }
    
    // Mapping of data
    private func receivedData(response: Response) {
        do {
            if let resp = try response.map(AccountResponseModel.self).user_info_token {
                guard let idUser = resp.id,
                    let nameUser = resp.name,
                    let emailUser = resp.email,
                    let balanceUser = resp.balance
                    else { print ("error")
                        return }
                ProfileDatabaseService().saveProfile(id: idUser, name: nameUser, email: emailUser, balance: balanceUser)
                delegate?.succeessProfile()
            }
        } catch {
            print("Unexpected error: \(error)")
            delegate?.errorProfile(text)
        }
    }
}
