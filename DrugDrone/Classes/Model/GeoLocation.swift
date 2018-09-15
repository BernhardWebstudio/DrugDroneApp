//
//  GeoLocation.swift
//  DrugDrone
//
//  Created by Michal Švácha on 15/09/2018.
//  Copyright © 2018 Michal Švácha. All rights reserved.
//

import Foundation
import ObjectMapper

class GeoLocation: Mappable {
    var altitude: Double?
    var latitude: Double?
    var longitude: Double?
    
    required init?(map: Map) {}
    
    private init() {}
    
    convenience init(altitude: Double, latitude: Double, longitude: Double) {
        self.init()
        
        self.altitude = altitude
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func mapping(map: Map) {
        altitude  <- map["alt"]
        latitude  <- map["lat"]
        longitude <- map["lon"]
    }
}
