//
//  Links.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 1/21/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import Foundation

enum Links: String {
    
    case site = "http://46.101.237.228:8080/rest-1.0"
    case chatSite = "http://46.101.237.228:8081"
//    case site = "http://localhost:8080"

    case regManager = "/reg/manager" //post
    case regDriver = "/reg/driver" //post
    case login = "/reg/login" //post
    case restore = "/reg/restore" //post
    
    case notifications = "/my/notifications" //get
    
    case companies = "/company/list" //get
    case company = "/company/" //get & delete
    case updateCompany = "/company" //post update & put create
    
    case trucks = "/trucks" //get
    
    case chats = "/chat/chats" //get
}
