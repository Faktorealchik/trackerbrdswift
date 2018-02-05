//
//  CompanyViewController.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 2/4/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftyJSON

class CompanyViewController: UIViewController {

    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var nameField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var addressField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var phoneField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var emailField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var company: Company?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        addressField.delegate = self
        phoneField.delegate = self
        emailField.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "checkmark"), style: .done, target: self, action: #selector(setCurrentCompany))
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.kbDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.kbDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    @objc private func setCurrentCompany(){
        guard let company = company else { createAlert(with: "There is no company"); return}
        let defaults = UserDefaults(suiteName: "ru.buyitfree")
        defaults?.set(company.id, forKey: "idCompany")
        defaults?.synchronize()
        buttonPressed(nil)
    }
    
    @objc func kbDidShow(notification: Notification){
        guard let info = notification.userInfo else { return }
        let frameSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: scrollView.contentSize.height + frameSize.height)
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: frameSize.height, right: 0)
    }
    
    @objc func kbDidHide(notification: Notification){
        guard let info = notification.userInfo else { return }
        let frameSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: scrollView.contentSize.height - frameSize.height)
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton?) {
        if nameField.text == "" || addressField.text == "" || phoneField.text == "" || emailField.text == "" {
            self.createAlert(with: "Please, fill in all fields")
            return
        }
        
        let newCompany = Company(id: company?.id ?? 0,
                                 name: nameField.text!,
                                 address: addressField.text!,
                                 phones: phoneField.text!,
                                 emails: emailField.text!)
        if company == nil {
            createCompany(newCompany)
        } else {
            updateCompany(newCompany)
        }
    }
    
    private func createCompany(_ company: Company){
        CompanyNetworkService.shared.addCompany(company) { [weak self] error in 
            if error != nil {
                self?.createAlert(with: error?.description)
            } else {
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                    let vc = self?.navigationController?.visibleViewController as? ModelViewSettingsTableViewController
                    self?.getCompanies(inVC: vc!)
                }
            }
        }
    }
    
    private func updateCompany(_ company: Company){
        CompanyNetworkService.shared.updateCompany(company) { [weak self] error in
            if error != nil {
                self?.createAlert(with: error?.description)
            } else {
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                    let vc = self?.navigationController?.visibleViewController as? ModelViewSettingsTableViewController
                    self?.getCompanies(inVC: vc!)
                }
            }
        }
    }
}

extension CompanyViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0: addressField.becomeFirstResponder()
        case 1: phoneField.becomeFirstResponder()
        case 2: emailField.becomeFirstResponder()
        case 3:
        view.endEditing(true)
        buttonPressed(nil)
        default:
            nameField.becomeFirstResponder()
        }
        return true
    }
}
