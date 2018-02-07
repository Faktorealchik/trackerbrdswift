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
        
        setupNavigationBar()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let destignationVC = storyboard?.instantiateViewController(withIdentifier: "AfterSettings") as! ModelViewSettingsTableViewController
        
        switch indexPath.row {
        case 0:
            destignationVC.title = "Notifications"
            navigationController?.pushViewController(destignationVC, animated: true)
            getNotifications(inVC: destignationVC)
        case 1:
            destignationVC.title = "Companies"
            let item = UIBarButtonItem(barButtonSystemItem: .add, target: destignationVC.self, action: #selector(destignationVC.companyRowAddAction))
            destignationVC.navigationItem.rightBarButtonItem = item
            navigationController?.pushViewController(destignationVC, animated: true)
            self.getCompanies(inVC: destignationVC)
        case 2: break
        case 3:
            destignationVC.title = "Trucks"
            let item = UIBarButtonItem(barButtonSystemItem: .add, target: destignationVC, action: #selector(destignationVC.truckRowAddAction))
            destignationVC.navigationItem.rightBarButtonItem = item
            navigationController?.pushViewController(destignationVC, animated: true)
            self.getTrucks(inVC: destignationVC)
        case 8:
            if MFMailComposeViewController.canSendMail() {
                sendEmail()
            }
        case 9:
            DispatchQueue.global().async {
                let userDefaults = UserDefaults(suiteName: "ru.buyitfree")
                userDefaults?.set(false, forKey: "rememberMe")
                userDefaults?.synchronize()
            }
            let vc = storyboard!.instantiateViewController(withIdentifier: "FirstNavigationController")
            self.show(vc, sender: self)
        default:
            break
        }
    }
    
    private func getNotifications(inVC viewController: ModelViewSettingsTableViewController){
        DispatchQueue.global().async {
            TracNotificationNetworkService.shared.getNotifications(completion: { [weak self] (notif, error) in
                guard error == nil else {
                    self?.createAlert(with: error?.localizedDescription)
                    return
                }
                DispatchQueue.main.async {
                    guard let notif = notif else {return}
                    var arr = [NotificationViewModel]()
                    for element in notif.notifications {
                        arr.append(NotificationViewModel(id: nil, description: element.time, name: element.description))
                    }
                    
                    viewController.elements = arr
                    viewController.tableView.reloadData()
                    viewController.spinner.stopAnimating()
                }
            })
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
