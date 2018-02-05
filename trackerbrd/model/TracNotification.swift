//
//  TracNotification.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 2/1/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import Foundation

struct TracNotification {
    let description: String
    let active: Bool
    let time: String
    let dateFormatter = DateFormatter()
    
    init?(dict: Json) {
        guard let description = dict["description"] as? String else { return nil}
        guard let isActive = dict["active"] as? Bool else { return nil}
        guard let time = dict["time"] as? Int64 else { return nil }
        
        dateFormatter.dateFormat = "dd.MM.yyyy hh:mm"
        let curTime = Date(timeIntervalSince1970: TimeInterval(time / 1000))
        let dateString = dateFormatter.string(from: curTime)
        
        self.description = description
        self.active = isActive
        self.time = dateString
    }
}
