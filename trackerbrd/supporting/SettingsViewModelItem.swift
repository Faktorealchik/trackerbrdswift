//
//  SettingsViewModelItem.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 2/3/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import UIKit

protocol SettingsViewModelItem {
    var id: Int64? { get }
    var name: String { get }
    var description: String { get }
    var type: SettingsViewModelType { get }
    var color: UIColor { get }
    
    var descClass: String { get }
}
