//
//  DroneAnnotation.swift
//  DrugDrone
//
//  Created by Michal Švácha on 15/09/2018.
//  Copyright © 2018 Michal Švácha. All rights reserved.
//

import Foundation
import MapKit

class DroneAnnotation: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return "Delivery drone"
    }
}

class DroneMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let _ = newValue as? DroneAnnotation else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            tintColor = .blue
            glyphImage = #imageLiteral(resourceName: "delivery")
        }
    }
}
