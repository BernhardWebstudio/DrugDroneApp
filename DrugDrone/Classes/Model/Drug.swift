//
//  Drug.swift
//  DrugDrone
//
//  Created by Michal Švácha on 15/09/2018.
//  Copyright © 2018 Michal Švácha. All rights reserved.
//

import Foundation

enum DrugType {
    case dose
    case pill
    case unknown
}

class Drug {
    var id: Int = 0
    var name: String = ""
    var description: String = ""
    var type: DrugType = .unknown
    
    init(id: Int, name: String, description: String, type: DrugType) {
        self.id = id
        self.name = name
        self.description = description
        self.type = type
    }
}
