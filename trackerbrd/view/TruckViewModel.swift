//
//  TruckViewModel.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 2/6/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import UIKit

class TruckViewModel: SettingsViewModelItem {
    let id: Int64?
    let name: String
    let description: String
    var color: UIColor
    let typeAvailable: Int
    
    var type: SettingsViewModelType {
        return .truck
    }
    
    var descClass: String {
        return "truck"
    }
    
    init(_ id:Int64, _ name: String, _ description: String, _ type: Int){
        self.id = id
        self.name = name
        self.description = description
        self.typeAvailable = type
        switch type {
        case 0:
            color = #colorLiteral(red: 0.450955987, green: 0.7979636192, blue: 0.2305333614, alpha: 1)
        case 1:
            color = #colorLiteral(red: 0.9307892919, green: 0.8807445168, blue: 0.1058603451, alpha: 1)
        case 2:
            color = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        default:
            color = .black
        }
    }
}
