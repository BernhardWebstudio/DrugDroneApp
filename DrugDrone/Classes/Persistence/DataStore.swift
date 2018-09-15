//
//  DataStore.swift
//  DrugDrone
//
//  Created by Michal Švácha on 15/09/2018.
//  Copyright © 2018 Michal Švácha. All rights reserved.
//

import Foundation
import ReactiveKit
import FirebaseDatabase
import ObjectMapper

enum AppError: Error {
    case clientError(error: Error)
    case serverError(error: String)
}

class DataStore {
    static let shared = DataStore()
    var database = Database.database()
    
    func nearestPharmacies() -> Signal<[CareProvider], AppError> {
        return Signal { observer in
            Client.shared.findNearestPharmacies(latitude: deviceLatitude, longitude: deviceLongitude) { result, error in
                if let error = error {
                    observer.failed(AppError.clientError(error: error))
                } else {
                    observer.completed(with: result)
                }
            }
            
            return NonDisposable.instance
        }
    }
    
    func takePill() -> Signal<Void, AppError> {
        return Signal { observer in
            Client.shared.takePill() { error in
                if let error = error {
                    observer.failed(AppError.clientError(error: error))
                } else {
                    observer.completed()
                }
            }
            
            return NonDisposable.instance
        }
    }
    
    func requestAirTraffic() -> Signal<AirTrafficResponse, AppError> {
        return Signal { observer in
            Client.shared.requestAirTraffic() { response, error in
                if let error = error {
                    observer.failed(AppError.clientError(error: error))
                } else if let value = response {
                    observer.completed(with: value)
                } else {
                    observer.failed(AppError.serverError(error: "No air traffic data!"))
                }
            }
            
            return NonDisposable.instance
        }
    }
    
    func requestDrone(drug: Drug, careProviders: [CareProvider], traffic: AirTrafficResponse) -> Signal<OrderDTO, AppError> {
        if careProviders.count == 0 {
            return Signal.failed(AppError.serverError(error: "No nearby services found."))
        }
        
        let nearestCareProvider = careProviders[0]
        let start = GeoLocation(altitude: 100, latitude: nearestCareProvider.geocode!.location!.latitude, longitude: nearestCareProvider.geocode!.location!.longitude)
        let end = GeoLocation(altitude: 100, latitude: deviceLatitude, longitude: deviceLongitude)
        
        return Signal { observer in
            Client.shared.requestDrone(start: start, end: end, traffic: traffic) { key, error in
                if let error = error {
                    observer.failed(AppError.clientError(error: error))
                } else if let key = key {
                    let order = OrderDTO(orderID: key, drug: drug, careProvider: nearestCareProvider)
                    observer.completed(with: order)
                } else {
                    observer.failed(AppError.serverError(error: "No drone is available at the moment."))
                }
            }
            
            return NonDisposable.instance
        }
    }
    
    func confirmDelivery(droneID: String) -> Signal<Void, AppError> {
        return Signal { observer in
            Client.shared.confirmDelivery(droneID: droneID) { error in
                if let error = error {
                    observer.failed(AppError.clientError(error: error))
                } else {
                    observer.completed()
                }
            }
            
            return NonDisposable.instance
        }
    }
    
    // MARK: - Firebase
    
    func write(trackingID: String, object: Drone) {
        let reference = database.reference().child("drones/\(trackingID)/drone")
        reference.setValue(object.toJSON())
    }
    
    func deliveryTracking(trackingID: String) -> Signal<Drone, NoError> {
        return database.reference().child("drones/\(trackingID)/drone").signalForEvent(event: .value)
            .map { $0.value as! [String: AnyObject] }
            .map { Mapper<Drone>().map(JSON: $0)! }
            .flatMapError { _ in Signal<Drone, NoError>.sequence([])}
    }
}
