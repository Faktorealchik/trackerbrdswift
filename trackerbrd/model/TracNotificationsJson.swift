//
//  TracNotifications.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 2/1/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct TracNotificationsJson {
    let notifications: [TracNotification]
    
    init(json: JSON) throws {
        var notif = [TracNotification]()
        
        for (_, subJson):(String, JSON) in json {
            guard let notification = TracNotification(dict: subJson.dictionaryObject!) else { continue }
            notif.append(notification)
        }
        
        self.notifications = notif
    }
}
