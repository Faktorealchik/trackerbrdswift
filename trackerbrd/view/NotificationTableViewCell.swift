//
//  NotificationTableViewCell.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 2/1/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var dataLabel: UILabel!
    
    var item: SettingsViewModelItem? {
        didSet {
            guard let item = item as? NotificationViewModel else { return }
            descriptionLabel.text = item.name
            dataLabel.text = item.description
        }
    }
}
