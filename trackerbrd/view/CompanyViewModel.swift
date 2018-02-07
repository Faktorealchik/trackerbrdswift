//
//  CompanyViewModel.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 2/3/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import UIKit

class CompanyViewModel: SettingsViewModelItem {
    let id: Int64?
    let name: String
    let description: String
    
    var color: UIColor {
        return .black
    }
    
    var type: SettingsViewModelType {
        return .company
    }
    
    var descClass: String {
        return "company"
    }
    
    init(_ id:Int64, _ name: String, _ description: String){
        self.id = id
        self.name = name
        self.description = description
    }
}
