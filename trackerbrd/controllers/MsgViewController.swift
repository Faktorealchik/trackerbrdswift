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
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        guard let info = notification.userInfo else { return }
        let frameSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
        bottomConstraint.constant = isKeyboardShowing ? -frameSize.height : 0
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            }) { [weak self] (completed) in
                guard let msg = self?.messages else { return }
                let lastItem = msg.count - 1
                let path = IndexPath(item: lastItem, section: 0)
                self?.collectionView.scrollToItem(at: path, at: .bottom, animated: true)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func onSend(_ sender: UIButton) {
        let text = textField.text
        let to = chat?.id
        let msg = Message(from: userId, text: text, to: to)
        let json = JSON(msg?.dict as Any)

        send(json.rawString()!)
    }
    @IBAction func onUpload(_ sender: UIButton) {
        
    }
}

extension MsgViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MessageCollectionViewCell
        
        cell.textLabel.text = messages?[indexPath.row].text
        
        cell.msgView.layer.cornerRadius = 15
        cell.msgView.clipsToBounds = true

        if let text = messages?[indexPath.row].text {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estHeight = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], context: nil)

            cell.textLabel.frame = CGRect(x: 16 + 8, y: 0, width: estHeight.width + 16, height: estHeight.height + 20)
            cell.msgView.frame = CGRect(x:16, y:0, width: estHeight.width + 16, height: estHeight.height + 50)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        textField.endEditing(true)
    }
}

extension MsgViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = messages?[indexPath.row]
        
        if let messageText = message?.text {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], context: nil)
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
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

