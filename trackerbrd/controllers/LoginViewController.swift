//
//  ViewController.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 1/16/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func close(segue: UIStoryboardSegue) {
        //performSegue(withIdentifier: "unwindToLogin", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    @objc private func kbDidShow(notification: Notification){
        guard let info = notification.userInfo else { return }
        let frameSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height + frameSize.height)
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: frameSize.height, right: 0)
    }
    
    @objc private func kbDidHide(){
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    }
    
    @IBAction func enterPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func rememberMePressed(_ sender: UISwitch) {
        
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0: passwordField.becomeFirstResponder()
        case 1: view.endEditing(true)
        default:
            loginField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}


