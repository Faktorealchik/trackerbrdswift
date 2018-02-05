//
//  NotificationViewModel.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 2/3/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import Foundation

class NotificationViewModel: SettingsViewModelItem {
    let name: String
    let description: String
    let id: Int64?
    
    var type: SettingsViewModelType {
        return .notifications
    }
    
    var descClass: String {
        return "notification"
    }
    
    init(id: Int64?, description: String, name: String){
        self.id = id
        self.description = description
        self.name = name
    }
}
