//
//  GeoCode.swift
//  DrugDrone
//
//  Created by Michal Švácha on 15/09/2018.
//  Copyright © 2018 Michal Švácha. All rights reserved.
//

import Foundation
import ObjectMapper

class GeoCode: Mappable {
    var location: Location?
    var placeID: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        location <- map["location"]
        placeID  <- map["place_id"]
    }
}
