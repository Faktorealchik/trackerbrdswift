//
//  User.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 1/16/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import Foundation

typealias Json = [String: Any]
struct User {
    
    public var dict: Json
    var id: Int
    var login: String
    var token: String
    var type: Int
    
    init?(dict: Json) {
        guard let user = dict["user"] as? Json,
        let token = dict["token"] as? String else { return nil }
        guard let login = user["login"] as? String,
            let type = user["type"] as? Int,
            let id = user["id"] as? Int
            else { return nil }
        
        self.login = login
        self.token = token
        self.id = id
        self.dict = dict
        self.type = type
    }
    
    init(with login: String, withMd5 password: String) {
        dict = [String: String]()
        dict["login"] = "\(login)"
        dict["password"] = "\(password)"
        self.login = login
        self.id = 0
        self.token = ""
        self.type = 0
    }
}

