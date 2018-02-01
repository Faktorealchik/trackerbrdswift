//
//  TracNotificationNetworkService.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 2/1/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import Foundation

import SwiftyJSON

class TracNotificationNetworkService{
    
    public static let shared = TracNotificationNetworkService()
    
    func getNotifications(completion: @escaping (TracNotificationsJson?, Error?) -> ()) {
        guard let url = URL(string: Links.site.rawValue + Links.notifications.rawValue) else { return }
        
        NetworkService.shared.getData(url: url) { (data, response, error) in
            guard error == nil else { completion(nil, error); return }
            guard let httpResponse = response as? HTTPURLResponse else { return }
            guard httpResponse.statusCode == 200 else {completion(nil, NetworkError.FailInternetError); return}
            guard let jsonArray = data else { completion(nil, NetworkError.FailInternetError); return}
            
            let js = JSON(jsonArray)
            do {
                let answer = try TracNotificationsJson(json: js)
                completion(answer, nil)
            }
            catch {
                print(error)
            }
        }
    }
}
