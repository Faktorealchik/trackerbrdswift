//
//  TruckNetworkService.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 2/5/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import SwiftyJSON

class TruckNetworkService {
    public static let shared = TruckNetworkService()
    
    func getListTrucks(id company: Int64, completion: @escaping (TrucksJson?, Message?) -> ()) {
        guard let url = URL(string: Links.site.rawValue + Links.trucks.rawValue + "?company=\(company)") else { return }
        
        NetworkService.shared.getData(url: url) { (data, response, error) in
            guard error == nil else { completion(nil, Message(error?.localizedDescription)); return }
            guard let jsonArray = data else { completion(nil, Message("fail to load data")); return}
            
            let js = JSON(jsonArray)
            let answer =  TrucksJson(with: js)
            completion(answer, nil)
        }
    }
}
