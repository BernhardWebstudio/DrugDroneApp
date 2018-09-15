//
//  Location.swift
//  DrugDrone
//
//  Created by Michal Švácha on 15/09/2018.
//  Copyright © 2018 Michal Švácha. All rights reserved.
//

import Foundation
import ObjectMapper

class Location: Mappable {
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        latitude  <- map["lat"]
        longitude <- map["lng"]
    }
}
