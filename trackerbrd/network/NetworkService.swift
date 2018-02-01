//
//  NetworkService.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 1/21/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import Foundation

class NetworkService {
    
    private init (){
        
    }
    
    public static let shared = NetworkService()
    
    public func getData(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let session = URLSession.shared
        let userDefaults = UserDefaults(suiteName: "ru.buyitfree")
        let token = userDefaults?.string(forKey: "token")
        let idUser = userDefaults?.integer(forKey: "idUser")
        guard idUser != nil else {completion(nil, nil, NetworkError.FailInternetError); return;}
        
        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "token")
        request.setValue(String(describing: idUser!), forHTTPHeaderField: "userId")
        
        DispatchQueue.main.async {
            session.dataTask(with: request) { (data, response, error) in
                completion(data, response, error)
            }.resume()
        }
    }
    
    public func postData(url: URL, data: Data, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        DispatchQueue.global().async {
            session.dataTask(with: request) { (data, response, error) in
            completion(data, response, error)
            }.resume()
        }
    }
}
