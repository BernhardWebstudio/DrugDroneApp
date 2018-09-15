//
//  AxaResponseWrapper.swift
//  DrugDrone
//
//  Created by Michal Švácha on 15/09/2018.
//  Copyright © 2018 Michal Švácha. All rights reserved.
//

import Foundation
import ObjectMapper

class AxaResponseWrapper<T: Mappable>: Mappable {
    
    var count: Int?
    var hasMore: Bool = false
    var result: [T] = []
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        count   <- map["count"]
        hasMore <- map["hasMore"]
        result  <- map["result"]
    }
}
