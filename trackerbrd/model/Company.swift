//
//  Company.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 2/3/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import Foundation

struct Company {
    let id: Int64
    let name: String
    let description: String?
    let address: String?
    let phones: String?
    let emails: String?
    let dictionary: [String: Any]?
    
    init?(with dict: Json) {
        guard let id = dict["id"] as? Int64,
            let name = dict["companyName"] as? String,
            let address = dict["address"] as? String,
            let phones = dict["phones"] as? String,
            let emails = dict["emails"] as? String
            else { return nil }
        
        self.id = id
        self.name = name
        self.address = address
        self.phones = phones
        self.emails = emails
        self.description = "\(id)"
        self.dictionary = nil
    }
    
    init?(companies dict: Json) {
        guard let id = dict["id"] as? Int64,
        let name = dict["name"] as? String,
        let description = dict["description"] as? String
        else {return nil}
        
        self.id = id
        self.name = name
        self.description = description
        self.address = nil
        self.phones = nil
        self.emails = nil
        self.dictionary = nil
    }
    
    init(id: Int64, name: String, address: String, phones: String, emails: String){
        self.id = id
        self.name = name
        self.address = address
        self.phones = phones
        self.emails = emails
        self.description = nil
        self.dictionary = [String: Any]()
        self.dictionary?["id"] = id
        self.dictionary?["companyName"] = name
        self.dictionary?["address"] = address
        self.dictionary?["phones"] = phones
        self.dictionary?["emails"] = emails
    }
}
