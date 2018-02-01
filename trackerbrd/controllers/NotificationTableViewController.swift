//
//  NotificationTableViewController.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 2/1/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import UIKit

class NotificationTableViewController: UITableViewController {
    var notifications: [TracNotification]!
    var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        title = "Notifications"
        getData()
        spinner = Utilits.setupSpinner(in: tableView)
    }
    
    private func getData(){
        DispatchQueue.global().async {
            TracNotificationNetworkService.shared.getNotifications(completion: { [weak self] (notif, error) in
                guard error == nil else {
                    self?.present(Utilits.createAlert(with: error?.localizedDescription), animated: true);
                    return
                }
                DispatchQueue.main.async {
                    self?.notifications = notif!.notifications
                    self?.tableView.reloadData()
                    self?.spinner.stopAnimating()
                }
            })
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard notifications != nil else {
            return 0
        }
        return notifications.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NotificationTableViewCell
        
        let notification = notifications[indexPath.row]
        cell.descriptionLabel.text = notification.description
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy hh:mm"
        let dateString = dateFormatter.string(from: notification.time)
        cell.dataLabel.text = dateString
        
        return cell
    }
}
