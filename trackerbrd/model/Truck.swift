//
//  Truck.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 2/5/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//
import Foundation
import SwiftyJSON

struct Truck {
    let id: Int64
    let name: String
    let number: String?
    let brand: String?
    let model: String?
    let techSert: String?
    let type: Int?
    let frame: String?
    let truckType: Int?
    let typeAvailable: Int?
    let description: String?
    
    let certType: String?
    let certSeries: String?
    let certNumber: String?
    let certDateExpire: Date?
    
    let lpackSeries: String?
    let lpackNumber: String?
    let lpackDateExpire: Date?
    
    let services: [TruckService]?
    
    init?(with dict: Json) {
        guard let id = dict["id"] as? Int64,
        let name = dict["name"] as? String else { return nil }
        let number = dict["number"] as? String
        let brand = dict["brand"] as? String
        let model = dict["model"] as? String
        let techSert = dict["techSert"] as? String
        let type = dict["type"] as? Int
        let frame = dict["frame"] as? String
        let truckType = dict["truckType"] as? Int
        let typeAvailable = dict["typeAvailable"] as? Int
        let description = dict["description"] as? String
        
        let certType = dict["certType"] as? String
        let certSeries = dict["certSeries"] as? String
        let certNumber = dict["certNumber"] as? String
        let certDateExpire = dict["certDateExpire"] as? Date
        
        let lpackSeries = dict["lpackSeries"] as? String
        let lpackNumber = dict["lpackNumber"] as? String
        let lpackDateExpire = dict["lpackDateExpire"] as? Date
        let truckServices = dict["services"] as? JSON
        
        self.id = id
        self.name = name
        self.number = number
        self.brand = brand
        self.model = model
        self.techSert = techSert
        self.type = type
        self.frame = frame
        self.truckType = truckType
        self.typeAvailable = typeAvailable
        self.description = description
        
        self.certType = certType
        self.certSeries = certSeries
        self.certNumber = certNumber
        self.certDateExpire = certDateExpire
        
        self.lpackSeries = lpackSeries
        self.lpackNumber = lpackNumber
        self.lpackDateExpire = lpackDateExpire
        
        guard let services = truckServices else {
            self.services = nil
            return
        }
        
        self.services = TruckServicesJson(with: services)?.services
    }
}

struct TruckService {
    let id: Int64
    let name: String
    let description: String
    let dateStart: Date
    let dateEnd: Date
    
    init?(with dict: Json){
        guard let id = dict["id"] as? Int64,
        let name = dict["name"] as? String,
        let description = dict["description"] as? String,
        let dateStart = dict["dateStart"] as? Date,
        let dateEnd = dict["dateEnd"] as? Date
        else {return nil}
        
        self.id = id
        self.name = name
        self.description = description
        self.dateStart = dateStart
        self.dateEnd = dateEnd
    }
}

struct TruckServicesJson {
    let services: [TruckService]
    
    init?(with dict: JSON){
        var serv = [TruckService]()
        
        for (_, subJson):(String, JSON) in dict {
            guard let service = TruckService(with: subJson.dictionaryObject!) else { continue }
            serv.append(service)
        }
        
        self.services = serv
    }
}
