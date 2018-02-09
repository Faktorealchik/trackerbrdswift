//
//  MsgViewController.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 2/8/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import UIKit
import Starscream
import SwiftyJSON

class MsgViewController: UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textField: UITextField!
    //@IBOutlet weak var sendButton: UIButton!
    
    var socket: WebSocket?
    var chat: Chat?{
        didSet{
            navigationItem.title = chat?.name
        }
    }
    var messages: [Message]?
    var userId: Int64!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socket?.delegate = self
        
        let userDefaults = UserDefaults(suiteName: "ru.buyitfree")
        userId = userDefaults?.object(forKey: "idUser") as! Int64
    }
    
    @IBAction func onSend(_ sender: UIButton) {
        let text = textField.text
        let to = chat?.id
        let msg = Message(from: userId, text: text, to: to)
        let json = JSON(msg?.dict as Any)
        
        send(json.rawString()!)
    }
}

extension MsgViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MessageCollectionViewCell
        
        cell.textLabel.text = messages?[indexPath.row].text
        
        cell.msgView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.msgView.layer.cornerRadius = 15
        cell.msgView.clipsToBounds = true
        
        if let text = messages?[indexPath.row].text {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estHeight = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], context: nil)
            cell.textLabel.frame = CGRect(x: 0, y: 0, width: estHeight.width + 16, height: estHeight.height + 20)
            
            cell.msgView.frame = CGRect(x:0, y:0, width: estHeight.width + 16, height: estHeight.height + 20)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages?.count ?? 1
    }
}

extension MsgViewController: WebSocketDelegate {
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        let json = JSON(text)
        let msg = Message(with: json.dictionaryObject!)
        messages?.append(msg!)
        collectionView.reloadData()
    }
    
    func send(_ string: String) {
        socket?.write(string: string)
    }
}

extension MsgViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let text = messages?[indexPath.row].text {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estHeight = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], context: nil)
            return CGSize(width: view.frame.width, height: estHeight.height + 50)
        }
        return CGSize(width: view.frame.width, height: 100)
    }
}





