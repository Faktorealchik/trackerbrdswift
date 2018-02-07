//
//  Message.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 2/4/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import SwiftyJSON

struct Message: Error {
    let description: String
    
    init(_ json: JSON){
        var msg = "Unknown exception"
        for (_, subJson):(String, JSON) in json {
             msg = subJson[0].dictionary?["message"]?.stringValue ?? "Unknown exception"
        }
        description = msg
    }
    
    init(_ reason: String?){
        description = reason ?? "Unknown exception"
    }
}
