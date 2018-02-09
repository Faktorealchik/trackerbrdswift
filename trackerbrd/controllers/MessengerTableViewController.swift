//
//  MessengerViewController.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 2/6/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import UIKit
import Starscream

class MessengerTableViewController: UITableViewController {
    var chats: [Chat]?
    let dateFormatter = DateFormatter()
    var socket: WebSocket?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async {
            let userDefaults = UserDefaults(suiteName: "ru.buyitfree")
            guard let id = userDefaults?.object(forKey: "idUser") as? Int64 else { return }
            self.socket = WebSocket(url: URL(string: "ws://localhost:8081/socket/\(id)")!, protocols: ["chat"])
            self.socket?.delegate = self
            self.socket?.connect()
        }
        
        self.dateFormatter.dateFormat = "HH:mm"
        
        self.setupNavigationBar()
    }
    
    deinit {
        socket?.disconnect(forceTimeout: 0)
        socket?.delegate = nil
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "msg" {
            let destVC = segue.destination as! MsgViewController
            let chat = chats?[(tableView.indexPathForSelectedRow?.row)!]
            destVC.chat = chat
            destVC.socket = self.socket
            getMessages(0, 20, chat!.id, destVC)
        }
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

extension MessengerTableViewController: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        print("connected")
    }
}
