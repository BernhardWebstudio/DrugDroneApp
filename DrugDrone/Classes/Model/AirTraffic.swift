//
//  AirTraffic.swift
//  DrugDrone
//
//  Created by Michal Švácha on 16/09/2018.
//  Copyright © 2018 Michal Švácha. All rights reserved.
//

import Foundation
import ObjectMapper

class AirTraffic: Mappable {
    var icao: String = ""
    var lat: Double = 0.0
    var lon: Double = 0.0
    var alt: Int = 0
    var speed: Double = 0.0
    var heading: Double = 0.0
    var lastUpdate: String = ""
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        icao       <- map["icao"]
        lat        <- map["lat"]
        lon        <- map["lon"]
        alt        <- map["alt"]
        speed      <- map["speed"]
        heading    <- map["heading"]
        lastUpdate <- map["last_update"]
    }
}
