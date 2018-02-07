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
    
    func getChats(completion: @escaping (ChatsJson?, Message?) -> ()) {
        guard let url = URL(string: Links.chatSite.rawValue + Links.chats.rawValue) else { return }
        
        NetworkService.shared.getData(url: url) { (data, response, error) in
            guard error == nil else { completion(nil, Message(error?.localizedDescription)); return }
            guard let jsonArray = data else { completion(nil, Message("fail to load data")); return}
            
            let js = JSON(jsonArray)
            let answer = ChatsJson(with: js)
            completion(answer, nil)
        }
    }
}
