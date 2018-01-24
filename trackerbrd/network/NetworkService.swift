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
        
        DispatchQueue.main.async {
            session.dataTask(with: url) { (data, response, error) in
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
