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
    
    func getListTrucks(completion: @escaping (TrucksJson?, Message?) -> ()) {
        guard let url = URL(string: Links.site.rawValue + Links.trucks.rawValue) else { return }
        
        NetworkService.shared.getData(url: url) { (data, response, error) in
            guard error == nil else { completion(nil, Message(error?.localizedDescription)); return }
            guard let jsonArray = data else { completion(nil, Message("fail to load data")); return}
            
            let js = JSON(jsonArray)
            do {
                let answer = try TrucksJson(with: js)
                completion(answer, nil)
            }
            catch {
                completion(nil, Message(error.localizedDescription))
            }
        }
    }
}
