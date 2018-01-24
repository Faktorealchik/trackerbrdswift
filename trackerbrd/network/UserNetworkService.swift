//
//  UserNetworkService.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 1/21/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserNetworkService{
    
    public static let shared = UserNetworkService()
    
    func login(with data: Data, completion: @escaping (User?, Error?) -> ()) {
        guard let url = URL(string: Links.site.rawValue + Links.login.rawValue) else { return }
        
        NetworkService.shared.postData(url: url, data: data) { (data, response, error) in
            guard error == nil else { completion(nil, error); return }
            guard let httpResponse = response as? HTTPURLResponse else { return }
            guard httpResponse.statusCode == 200 else { completion(nil, NetworkError.FailInternetError); return }
            guard let json = data else { completion(nil, NetworkError.FailInternetError); return }
            
            let js = JSON(json)
            let user = User(dict: js.dictionaryObject!)
    
            completion(user, nil)
        }
    }
    
    func getUser() {
        
    }
}
