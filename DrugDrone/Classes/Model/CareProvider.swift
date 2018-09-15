//
//  CareProvider.swift
//  DrugDrone
//
//  Created by Michal Švácha on 15/09/2018.
//  Copyright © 2018 Michal Švácha. All rights reserved.
//

import Foundation
import ObjectMapper

enum CareTakerCategory: String {
    case pharmacies = "5b33a5142c9dd24355626305"
}

class CareProvider: Mappable {
    var distance: Int?
    var email: String?
    var geocode: GeoCode?
    var name: String?
    var title: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        distance <- map["distance"]
        email    <- map["email"]
        geocode  <- map["geocode"]
        name     <- map["name"]
        title    <- map["title"]
    }
}
