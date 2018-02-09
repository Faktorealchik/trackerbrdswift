//
//  MessengerNetworkService.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 2/7/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import SwiftyJSON

class MessengerNetworkService {
    public static let shared = MessengerNetworkService()
    
    func getChats(completion: @escaping (ChatsJson?, ErrorMessage?) -> ()) {
        guard let url = URL(string: Links.chatSite.rawValue + Links.chats.rawValue) else { return }
        
        NetworkService.shared.getData(url: url) { (data, response, error) in
            guard error == nil else { completion(nil, ErrorMessage(error?.localizedDescription)); return }
            guard let jsonArray = data else { completion(nil, ErrorMessage("fail to load data")); return}
            
            let js = JSON(jsonArray)
            let answer = ChatsJson(with: js)
            completion(answer, nil)
        }
    }
    
    func getMessages(_ from: Int, _ to: Int, _ chat: Int64, completion: @escaping (MessagesJson?, ErrorMessage?) -> ()) {
        guard let url = URL(string: Links.chatSite.rawValue + Links.msg.rawValue + "?from=\(from)&size=\(to)&idChat=\(chat)") else { return }
        
        NetworkService.shared.getData(url: url) { (data, response, error) in
            guard error == nil else { completion(nil, ErrorMessage(error?.localizedDescription)); return }
            guard let jsonArray = data else { completion(nil, ErrorMessage("fail to load data")); return}
            
            let js = JSON(jsonArray)
            let answer = MessagesJson(with: js)
            completion(answer, nil)
        }
    }
}
