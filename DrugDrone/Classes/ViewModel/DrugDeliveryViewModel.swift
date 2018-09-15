//
//  DrugDeliveryViewModel.swift
//  DrugDrone
//
//  Created by Michal Švácha on 15/09/2018.
//  Copyright © 2018 Michal Švácha. All rights reserved.
//

import Foundation
import ReactiveKit
import Bond

class DrugDeliveryViewModel {
    let dataStore = DataStore.shared
    var droneBinding: Disposable?
    
    var order: OrderDTO?
    
    func droneTracking() -> Signal<Drone, NoError> {
        return dataStore.deliveryTracking(trackingID: order!.orderID)
    }
    
    func move(drone: Drone) {
        guard let trackingID = order?.orderID else { return }
        if drone.currentLocation + 1 == drone.waypoints.count {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [unowned self] in
            drone.currentLocation += 1
            self.dataStore.write(trackingID: trackingID, object: drone)
        }
    }
    
    func confirmDelivery() -> Signal<LoadingState<Void, AppError>, NoError> {
        return dataStore.confirmDelivery(droneID: order!.orderID).toLoadingSignal()
    }
}
