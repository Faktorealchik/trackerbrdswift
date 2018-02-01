//
//  Utilits.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 2/1/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import Foundation
import UIKit

class Utilits {
    
    public static func createAlert(with error: String?) -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: error ?? "Unexpected error", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        return alert
    }
    
    public static func setupSpinner(in view: UIView) -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        spinner.activityIndicatorViewStyle = .whiteLarge
        spinner.color = UIColor.gray
        spinner.center = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.height/2 - 100)
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        view.addSubview(spinner)
        return spinner
    }
}
