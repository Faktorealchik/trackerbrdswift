//
//  Chat.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 2/7/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Chat {
    let id: Int64
    let name: String
    let creater: Int64
    let unreadMsg: Int
    let lastMsg: String?
    let lastMsgTime: Date?
    let dateCreated: Date
    
    init?(with dict: Json) {
        guard let id = dict["id"] as? Int64,
            //let name = dict["name"] as? String,
            let creater = dict["idUserCreater"] as? Int64,
            let dateCreated = dict["dateCreated"] as? Int64,
            let unreadMsg = dict["unread"] as? Int else {return nil}
        self.id = id
        self.name = "name"
        self.creater = creater
        self.unreadMsg = unreadMsg
        self.dateCreated = Date(timeIntervalSince1970: TimeInterval(dateCreated / 1000))
        self.lastMsg = dict["lastMessage"] as? String
        
        if let lastMsgTime = dict["lastMessageTime"] as? Int64 {
            self.lastMsgTime = Date(timeIntervalSince1970: TimeInterval(exactly: lastMsgTime / 1000)!)
        } else {
            self.lastMsgTime = nil
        }
    }
}

struct ChatsJson {
    let chats: [Chat]
    
    init(with json: JSON) {
        var chats = [Chat]()
        
        for (_, subJson):(String, JSON) in json {
            guard let chat = Chat(with: subJson.dictionaryObject!) else { continue }
            chats.append(chat)
        }
        
        self.chats = chats
    }
}
