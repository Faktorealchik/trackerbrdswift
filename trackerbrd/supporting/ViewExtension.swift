//
//  ViewExtension.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 2/2/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import UIKit

extension UIView {
    public func setupSpinner() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        spinner.activityIndicatorViewStyle = .whiteLarge
        spinner.color = UIColor.gray
        spinner.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.height/2 - 100)
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        self.addSubview(spinner)
        return spinner
    }
}

extension UIViewController {
    public func createAlert(with error: String?) {
        let alert = UIAlertController(title: "Error", message: error ?? "Unexpected error", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    func getCompanies(inVC viewController: ModelViewSettingsTableViewController) {
        DispatchQueue.global().async {
            CompanyNetworkService.shared.getListCompanies(completion: { [weak self] (comp, error) in
                guard error == nil else {
                    self?.createAlert(with: error?.description)
                    return
                }
                DispatchQueue.main.async {
                    guard let comp = comp else { return }
                    var arr = [CompanyViewModel]()
                    for element in comp.companies {
                        arr.append(CompanyViewModel(element.id, element.name, element.description ?? "no description"))
                    }
                    if arr.count == 1 {
                        let defaults = UserDefaults(suiteName: "ru.buyitfree")
                        defaults?.set(arr[0].id, forKey: "idCompany")
                        defaults?.synchronize()
                    }
                    viewController.elements = arr
                    viewController.tableView.reloadData()
                    viewController.spinner.stopAnimating()
                }
            })
        }
    }
    
    func getTrucks(inVC viewController: ModelViewSettingsTableViewController){
        DispatchQueue.global().async {
            TruckNetworkService.shared.getListTrucks(completion: { [weak self] (comp, error) in
                guard error == nil else {
                    self?.createAlert(with: error?.description)
                    return
                }
                DispatchQueue.main.async {
                    guard let comp = comp else { return }
                    var arr = [CompanyViewModel]()
                    for element in comp.companies {
                        arr.append(CompanyViewModel(element.id, element.name, element.description ?? "no description"))
                    }
                    if arr.count == 1 {
                        let defaults = UserDefaults(suiteName: "ru.buyitfree")
                        defaults?.set(arr[0].id, forKey: "idCompany")
                        defaults?.synchronize()
                    }
                    viewController.elements = arr
                    viewController.tableView.reloadData()
                    viewController.spinner.stopAnimating()
                }
            })
        }
    }
}
