//
//  CompanyTableViewCell.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 2/3/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import UIKit

class StandartTableViewCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var country: UILabel!
    
    var item: SettingsViewModelItem? {
        didSet {
            guard let item = item else { return }
            name.text = item.name
            name.textColor = item.color
            country.text = item.description
            country.textColor = item.color
        }
    }
}
