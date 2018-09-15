//
//  Client.swift
//  DrugDrone
//
//  Created by Michal Švácha on 15/09/2018.
//  Copyright © 2018 Michal Švácha. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class Client {
    static let shared = Client()
    
    func findNearestPharmacies(latitude: Double, longitude: Double, completion: @escaping (_ careProviders: [CareProvider], _ error: Error?) -> Void) {
        let parameters: Parameters = [
            "nearLat": latitude,
            "nearLng": longitude,
            "nearLimit": 10,
            "category": CareTakerCategory.pharmacies.rawValue
        ]
        
        let request = Router.careProviders(parameters)
        Alamofire.request(request).responseObject { (response: DataResponse<AxaResponseWrapper<CareProvider>>) in
            switch response.result {
            case .success(let value):
                completion(value.result, nil)
            case .failure(let error):
                completion([], error)
            }
        }
    }
    
    func takePill(completion: @escaping (_ error: Error?) -> Void) {
        let request = Router.takePill
        Alamofire.request(request).responseString { response in
            switch response.result {
            case .success(let value):
                if value == "OK" {
                    completion(nil)
                } else {
                    completion(NSError(domain: "", code: -1, userInfo: nil))
                }
            case .failure(let error):
                completion(error)
            }
        }
    }
}
