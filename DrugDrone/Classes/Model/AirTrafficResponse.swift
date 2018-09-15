//
//  AirTrafficResponse.swift
//  DrugDrone
//
//  Created by Michal Švácha on 16/09/2018.
//  Copyright © 2018 Michal Švácha. All rights reserved.
//

import Foundation
import ObjectMapper

class AirTrafficResponse: Mappable {
    var timestamp: String = ""
    var data: [AirTraffic] = []
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        timestamp <- map["timestamp"]
        data      <- map["data"]
    }
}
