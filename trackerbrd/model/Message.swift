//
//  Message.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 2/8/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Message {
    let text: String?
    let to: Int64?
    let from: Int64
    var dict: Json?
    let timeCreated: Date?
    
    init?(from: Int64, text: String?, to: Int64?) {
        self.from = from
        self.text = text
        self.to = to
        self.timeCreated = nil
        
        dict = Json()
        dict?["text"] = text
        dict?["to"] = to
        dict?["from"] = from
        dict?["type"] = 0
    }
    
    init?(with dictionary: Json){
        guard let text = dictionary["text"] as? String,
        let idChat = dictionary["idChat"] as? Int64,
        let idUser = dictionary["idUser"] as? Int64,
        let timeCreated = dictionary["dateCreated"] as? Int64
            else { return nil }

        self.text = text
        self.to = idChat
        self.from = idUser
        self.timeCreated = Date(timeIntervalSince1970: TimeInterval(exactly: timeCreated / 1000)!)
        self.dict = nil
    }
}

struct MessagesJson {
    let messages: [Message]
    
    init(with json: JSON) {
        var msg = [Message]()
        
        for (_, subJson):(String, JSON) in json {
            guard let message = Message(with: subJson.dictionaryObject!) else { continue }
            msg.append(message)
        }
        
        self.messages = msg
    }
}
