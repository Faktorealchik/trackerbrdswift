//
//  ViewController.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 1/16/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftyJSON

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var passwordField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var forgetPassowrdButton: UIButton!
    private var rememberMe = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forgetPassowrdButton.isHidden = true
        loginField.errorColor = .red
        loginField.delegate = self
        passwordField.errorColor = .red
        passwordField.delegate = self
        navigationController?.navigationBar.isHidden = true
        activityIndicator.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.kbDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.kbDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    @objc func kbDidShow(notification: Notification){
        guard let info = notification.userInfo else { return }
        let frameSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        scrollView?.contentSize = CGSize(width: self.view.bounds.size.width, height: scrollView.contentSize.height + frameSize.height)
        scrollView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: frameSize.height, right: 0)
    }
    
    @objc func kbDidHide(notification: Notification){
        guard let info = notification.userInfo else { return }
        let frameSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        scrollView?.contentSize = CGSize(width: self.view.bounds.size.width, height: scrollView.contentSize.height - frameSize.height)
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    @IBAction func forgetPasswordButtonPressed(_ sender: UIButton) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        forgetPassowrdButton.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func enterPressed(_ _: UIButton) {
        guard let login = loginField.text,
            let password = passwordField.text else {return}
        if login != "" && password != "" {
            makeRequestForUser(login, password)
        } else {
            let reason = login == "" ? "email" : "password"
            self.createAlert(with: "Please, fill in your \(reason)")
        }
    }
    
    private func makeRequestForUser(_ login: String, _ password: String) {
        enterButton.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        do{
            try processRequest(login, password.md5)
        } catch {
            self.doMainAsync {
                self.enterButton.isHidden = false
                self.createAlert(with: error.localizedDescription)
                self.activityIndicator.isHidden = true
                return
            }
        }
    }
    
    private func processRequest(_ login: String, _ password: String) throws {
        let usr = User(with: login, withMd5: password).dict
        let data = try JSON(usr).rawData()
        UserNetworkService.shared.login(with: data){ [weak self] (user, error) in
            guard error == nil else {
                self?.doMainAsync {
                    self?.createAlert(with: "Password incorrect")
                    self?.enterButton.isHidden = false
                    self?.activityIndicator.isHidden = true
                    self?.forgetPassowrdButton.isHidden = false
                }
                return
            }
            guard let user = user else {return}
            
            DispatchQueue.main.sync {
                self?.dismiss(animated: true)
                let userDefaults = UserDefaults(suiteName: "ru.buyitfree")
                userDefaults?.set(user.token, forKey: "token")
                userDefaults?.set(user.type, forKey: "type")
                userDefaults?.set(user.id, forKey: "idUser")
                userDefaults?.set(self?.rememberMe, forKey: "rememberMe")
                userDefaults?.synchronize()
                self?.enterButton.isHidden = false
                self?.activityIndicator.isHidden = true
                self?.show((self?.storyboard?.instantiateInitialViewController())!, sender: self)
            }
        }
    }

    private func doMainAsync(execute work: @escaping () -> ()){
        DispatchQueue.main.async {
            work()
        }
    }
    
    @IBAction func rememberMePressed(_ sender: UISwitch) {
        rememberMe = sender.isOn
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0: passwordField.becomeFirstResponder()
        case 1: view.endEditing(true)
        guard let login = loginField.text,
            let pass = passwordField.text else {return true}
        makeRequestForUser(login, pass)
        default:
            loginField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        guard let text = textField.text,
            let floatingLabelTextField = textField as? SkyFloatingLabelTextFieldWithIcon
            else { return true }
        
        if textField.tag == 0 && (text.count < 3 || !text.contains("@") || !text.contains(".")) {
            floatingLabelTextField.errorMessage = "Invalid email"
        } else {
            floatingLabelTextField.errorMessage = ""
        }
        return true
    }
}
