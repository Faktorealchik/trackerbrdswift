//
//  ManagerSettingsViewController.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 1/28/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import UIKit
import MessageUI

class ManagerSettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 8 && MFMailComposeViewController.canSendMail() {
            sendEmail()
        }
    }
    
    func sendEmail() {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients(["trackerbrd@gmail.com"])
        composeVC.setSubject("Hello, I`m writing from IOS application!")
        composeVC.setMessageBody("Hello! I need to say, that...", isHTML: false)
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
