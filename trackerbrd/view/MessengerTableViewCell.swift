//
//  MessengerTableViewCell.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 2/7/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import UIKit

class MessengerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var unreadMessages: UILabel!
}
