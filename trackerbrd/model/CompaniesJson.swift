//
//  CompaniesJson.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 2/3/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CompaniesJson {
    let companies: [Company]
    
    init(with json: JSON) {
        var companies = [Company]()
        
        for (_, subJson):(String, JSON) in json {
            guard let company = Company(companies: subJson.dictionaryObject!) else { continue }
            companies.append(company)
        }
        
        self.companies = companies
    }
    
    init(one json: JSON) {
        var companies = [Company]()
        print(json)
        for (_, _):(String, JSON) in json {
            guard let company = Company(with: json.dictionaryObject!) else { continue }
            companies.append(company)
        }
        
        self.companies = companies
    }
}
