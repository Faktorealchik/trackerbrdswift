//
//  Truck.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 2/5/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import Foundation

struct Truck {
    let id: Int64
    let name: String
    let number: String
    let brand: String
    let model: String
    let techSert: String
    let type: Int
    let frame: String
    let truckType: Int
    let typeAvailable: Int
    let description: String
    
    let certType: String
    let certSeries: String
    let certNumber: String
    let certDateExpire: Date
    
    let lpackSeries: String
    let lpackNumber: String
    let lpackDateExpire: String
    
    let services: [TruckServices]
    
    
//    init?(with dict: Json) {
//
//    }
}

struct TruckServices {
    let id: Int64
    let name: String
    let description: String
    let dateStart: Date
    let dateEnd: Date
    
//    init(with dict: Json){
//        
//    }
}
