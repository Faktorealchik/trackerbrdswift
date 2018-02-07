//
//  MessengerViewController.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 2/6/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import UIKit

class MessengerTableViewController: UITableViewController {
    var chats: [Chat]?
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateFormatter.dateFormat = "HH:mm"
        
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getChats()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats?.count ?? 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = chats?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MessengerTableViewCell
        
        cell.title.text = chat?.name
        cell.message.text = chat?.lastMsg
        if let time = chat?.lastMsgTime {
            cell.time.text = dateFormatter.string(from: time)
        } else {
            cell.time.text = dateFormatter.string(from: chat?.dateCreated ?? Date())
        }
        if let unread = chat?.unreadMsg, unread > 0 {
            cell.unreadMessages.text = "\(unread)"
            cell.unreadMessages.isHidden = false
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MessengerTableViewController {
    
    private func getChats(){
        MessengerNetworkService.shared.getChats { [weak self] (chats, error) in
            guard error == nil else {
                self?.createAlert(with: error?.description)
                return
            }
            DispatchQueue.main.async {
                self?.chats = chats?.chats.sorted(by: { (chat1, chat2) -> Bool in
                    guard let first = chat1.lastMsgTime?.millisecondsSince1970 else {return false}
                    guard let second = chat2.lastMsgTime?.millisecondsSince1970 else {return true}
                    return first > second
                })
                self?.tableView.reloadData()
            }
        }
    }
}
