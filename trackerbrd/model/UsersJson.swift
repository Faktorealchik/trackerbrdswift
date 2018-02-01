////
////  UserJson.swift
////  trackerbrd
////
////  Created by Alexandr Nesterov on 1/21/18.
////  Copyright © 2018 Alexandr Nesterov. All rights reserved.
////
//
//import Foundation
//
//public typealias JSONArray = [[String: AnyObject]]
//
//struct UsersJson {
//    let users: [User]
//    
//    init(json: Any) throws {
//        guard let array = json as? JSONArray else { throw NetworkError.FailInternetError }
//
//        var users = [User]()
//
//        for dictionary in array {
//            guard let user = User(dict: dictionary) else { continue }
//            users.append(user)
//        }
//        self.users = users
//    }
//}

