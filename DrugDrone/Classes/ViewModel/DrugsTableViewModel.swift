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
    
    init() {
        drugs.append(Drug(id: 0, name: "Januvia", description: "Diabetes", type: .dose))
        drugs.append(Drug(id: 0, name: "Benadryl", description: "Allergy", type: .pill))
        drugs.append(Drug(id: 0, name: "Ibuprofen", description: "Headache", type: .pill))
        drugs.append(Drug(id: 0, name: "Keytruda", description: "Cancer treatment", type: .unknown))
    }
    
    func helperPickupFunction(careProviders: [CareProvider]) -> Signal<[CareProvider], AppError> {
        return dataStore.takePill().map {
            return careProviders
        }
    }
    
    func placeOrder(for drug: Drug) -> Signal<LoadingState<OrderDTO, AppError>, NoError> {
        return dataStore.nearestPharmacies()
            //.flatMapLatest { [unowned self] in self.helperPickupFunction(careProviders: $0) }
            .flatMapLatest { [unowned self] (careProviders) -> Signal<OrderDTO, AppError> in
                self.dataStore.placeOrder(drug: drug, careProviders: careProviders)
            }.toLoadingSignal()
    }
}
