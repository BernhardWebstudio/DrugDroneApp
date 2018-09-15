//
//  DrugsTableViewModel.swift
//  DrugDrone
//
//  Created by Michal Švácha on 15/09/2018.
//  Copyright © 2018 Michal Švácha. All rights reserved.
//

import Foundation
import ReactiveKit
import Bond

class DrugsTableViewModel {
    let dataStore = DataStore.shared
    
    let drugs = MutableObservableArray<Drug>([])
    
    typealias DroneRequestDTO = (careProviders: [CareProvider], airTraffic: AirTrafficResponse)
    
    init() {
        drugs.append(Drug(id: 0, name: "Januvia", description: "Diabetes", type: .dose))
        drugs.append(Drug(id: 1, name: "Benadryl", description: "Allergy", type: .pill))
        drugs.append(Drug(id: 2, name: "Ibuprofen", description: "Headache", type: .pill))
        drugs.append(Drug(id: 3, name: "Keytruda", description: "Cancer treatment", type: .unknown))
    }
    
    func helperPickupFunction(careProviders: [CareProvider]) -> Signal<[CareProvider], AppError> {
        return dataStore.takePill().map {
            return careProviders
        }
    }
    
    func helperAirTraffic(careProviders: [CareProvider]) -> Signal<DroneRequestDTO, AppError> {
        return dataStore.requestAirTraffic().map { data in
            return (careProviders, data)
        }
    }
    
    func placeOrder(for drug: Drug) -> Signal<LoadingState<OrderDTO, AppError>, NoError> {
        if drug.name == "Ibuprofen" {
            return dataStore.nearestPharmacies()
                .flatMapLatest { [unowned self] in self.helperPickupFunction(careProviders: $0) }
                .flatMapLatest { [unowned self] in self.helperAirTraffic(careProviders: $0) }
                .flatMapLatest { [unowned self] (request) -> Signal<OrderDTO, AppError> in
                    self.dataStore.requestDrone(drug: drug, careProviders: request.careProviders, traffic: request.airTraffic)
                }.toLoadingSignal()
        } else {
            return dataStore.nearestPharmacies()
                .flatMapLatest { [unowned self] in self.helperAirTraffic(careProviders: $0) }
                .flatMapLatest { [unowned self] (request) -> Signal<OrderDTO, AppError> in
                    self.dataStore.requestDrone(drug: drug, careProviders: request.careProviders, traffic: request.airTraffic)
                }.toLoadingSignal()
        }
    }
}
