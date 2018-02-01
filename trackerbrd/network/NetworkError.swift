//
//  NetworkError.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 1/21/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case FailInternetError
    case noInternetConnection
    case BadReturnType
    
}
