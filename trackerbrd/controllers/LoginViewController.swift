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
    private var rememberMe = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginField.errorColor = .red
        loginField.delegate = self
        passwordField.errorColor = .red
        passwordField.delegate = self
        navigationController?.navigationBar.isHidden = true
        activityIndicator.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userDefaults = UserDefaults(suiteName: "ru.buyitfree")
        let token = userDefaults?.string(forKey: "token")
        let remember = userDefaults?.bool(forKey: "rememberMe")
        let type = userDefaults?.integer(forKey: "type")
        if token != nil && type != nil && remember != nil && remember! {
            performSegue(type!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
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
        guard let login = loginField.text,
            let password = passwordField.text else {return}
        if login != "" && password != "" {
            sender.isHidden = true
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            makeRequestForUser(login, password, sender)
        } else {
            let reason = login == "" ? "email" : "password"
            self.createAlert(with: "Please, fill in your \(reason)")
        }
    }
    
    private func makeRequestForUser(_ login: String, _ password: String, _ sender: UIButton) {
        do{
            try processRequest(login, password, sender)
        } catch {
            self.doMainAsync {
                sender.isHidden = false
            }
            self.createAlert(with: error.localizedDescription)
            self.hideActivityIndicator()
            return
        }
    }
    
    private func processRequest(_ login: String, _ password: String, _ sender: UIButton) throws {
        let usr = User(with: login, withMd5: password).dict
        let data = try JSON(usr).rawData()
        UserNetworkService.shared.login(with: data){ [weak self] (user, error) in
            guard error == nil else {
                self?.createAlert(with: "Password incorrect")
                //self?.showButton(sender)
                self?.doMainAsync {
                    sender.isHidden = false
                }
                self?.hideActivityIndicator()
                return
            }
            guard let user = user else {
                return
            }
            
            DispatchQueue.main.sync {
                let userDefaults = UserDefaults(suiteName: "ru.buyitfree")
                userDefaults?.set(user.token, forKey: "token")
                userDefaults?.set(user.type, forKey: "type")
                userDefaults?.set(self?.rememberMe, forKey: "rememberMe")
                userDefaults?.synchronize()
                self?.hideActivityIndicator()
                self?.performSegue(user.type)
            }
        }
    }
    
    private func doMainAsync(execute work: @escaping () -> ()){
        DispatchQueue.main.async {
            work()
        }
    }
    
    private func showButton(_ button: UIButton){
        doMainAsync {
            button.isHidden = false
        }
    }

    private func hideActivityIndicator() {
        doMainAsync {
            self.activityIndicator.isHidden = true
        }
    }
    
    private func createAlert(with error: String?) {
        doMainAsync {
            let alert = UIAlertController(title: "Error", message: error ?? "Unexpected error", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
    }
    
    private func performSegue(_ type: Int){
        if type == 0 {
            self.performSegue(withIdentifier: "segueManager", sender: self)
        } else {
            self.performSegue(withIdentifier: "segueDriver", sender: self)
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
        //perform login
        default:
            loginField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
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
