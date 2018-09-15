//
//  Drone.swift
//  DrugDrone
//
//  Created by Michal Švácha on 15/09/2018.
//  Copyright © 2018 Michal Švácha. All rights reserved.
//

import Foundation
import ObjectMapper

class Drone: Mappable {
    var currentLocation: Int = 0
    var droneDestination: GeoLocation?
    var droneOrigin: GeoLocation?
    var pharma: GeoLocation?
    var waypoints: [GeoLocation] = []
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        currentLocation  <- map["currentLocation"]
        droneDestination <- map["end"]
        droneOrigin      <- map["start"]
        pharma           <- map["pharma"]
        waypoints        <- map["pathPoints"]
    }
}
