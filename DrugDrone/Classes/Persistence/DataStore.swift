//
//  DataStore.swift
//  DrugDrone
//
//  Created by Michal Švácha on 15/09/2018.
//  Copyright © 2018 Michal Švácha. All rights reserved.
//

import Foundation
import ReactiveKit

enum AppError: Error {
    case clientError(error: Error)
    case serverError(error: String)
}

class DataStore {
    static let shared = DataStore()
    
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
    
    func placeOrder(drug: Drug, careProviders: [CareProvider]) -> Signal<OrderDTO, AppError> {
        if careProviders.count == 0 {
            return Signal.failed(AppError.serverError(error: "No nearby services found."))
        }
        
        return Signal { observer in
            let nearestCareProvider = careProviders[0]
            let order = OrderDTO(orderID: "test", careProvider: nearestCareProvider)
            observer.completed(with: order)
            
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
}
