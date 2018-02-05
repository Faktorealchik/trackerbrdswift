//
//  TrucksJson.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 2/5/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import SwiftyJSON

struct TrucksJson {
    let trucks: [Truck]
    
    init(with json: JSON) throws {
        var trucks = [Truck]()
        
        for (_, subJson):(String, JSON) in json {
            guard let truck = Truck(with: subJson.dictionaryObject!) else { continue }
            trucks.append(truck)
        }
        
        self.trucks = trucks
    }
}
