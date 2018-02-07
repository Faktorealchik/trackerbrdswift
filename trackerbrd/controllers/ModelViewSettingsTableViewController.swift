//
//  ModelViewSettingsTableViewController.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 2/3/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import UIKit

class ModelViewSettingsTableViewController: UITableViewController {
    var elements: [SettingsViewModelItem]?
    var spinner: UIActivityIndicatorView!
    var idCompany: Int64?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner = tableView.setupSpinner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults(suiteName: "ru.buyitfree")
        idCompany = defaults?.object(forKey: "idCompany") as? Int64
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let elements = elements, elements.count > 0 else {return false}
        let el = elements[0]
        
        if el.type != .notifications {
            return true
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let element = self.elements?[indexPath.row] else { return }
            let alert = UIAlertController(title: "Delete company", message: "Are you shure you want to delete \(element.descClass) ?", preferredStyle: .alert)
            let delete = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (action) in
                switch element.type {
                case .company:
                    self?.deleteCompany(element.id!, for: indexPath)
                default:
                    break
                }
                DispatchQueue.main.async {
                    self?.elements?.remove(at: indexPath.row)
                    self?.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
            let cansel = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(delete)
            alert.addAction(cansel)
            self.present(alert, animated: true)
        }
    }
    
    private func deleteCompany(_ id: Int64, for indexPath: IndexPath){
        CompanyNetworkService.shared.deleteCompany(id) {[weak self] error in
            guard error == nil else {
                self?.createAlert(with: error?.description)
                return
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = self.elements?[indexPath.row] else { return UITableViewCell() }
        
        switch item.type {
        case .notifications:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Notification") as! NotificationTableViewCell
            cell.item = item
            return cell
        case .company:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Common") as! StandartTableViewCell
            cell.item = item
            if item.id == idCompany {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .detailDisclosureButton
            }
            return cell
        case .truck:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Common") as! StandartTableViewCell
            cell.item = item
            cell.accessoryType = .disclosureIndicator
            return cell
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let elements = elements else {return}
        switch elements[indexPath.row].type {
        case .notifications:
            break
        case .company:
            let vc = storyboard?.instantiateViewController(withIdentifier: "CompanyVC") as? CompanyViewController
            self.getOneCompany(id: elements[indexPath.row].id!, inVC: vc)
            navigationController?.pushViewController(vc!, animated: true)
            break
        default:
            break
        }
    }
    
    private func getOneCompany(id company: Int64, inVC vc: CompanyViewController?) {
        CompanyNetworkService.shared.getOneCompany(with: company) { (companies, error) in
            guard error == nil else {
                self.createAlert(with: error?.description)
                return
            }
            let company = companies?.companies[0]
            
            DispatchQueue.main.async {
                vc?.company = company
                vc?.nameField.text = company?.name
                vc?.addressField.text = company?.address
                vc?.emailField.text = company?.emails
                vc?.phoneField.text = company?.phones
            }
        }
    }
    
    @objc func companyRowAddAction(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "CompanyVC") as? CompanyViewController
        navigationController?.pushViewController(vc!, animated: true)
    }

    @objc func truckRowAddAction(){
        
    }
    
    @objc func trailerRowAddAction(){
        
    }
    
    @objc func managerRowAddAction(){
        
    }
    
    @objc func controlPointRowAddAction(){
        
    }
}
