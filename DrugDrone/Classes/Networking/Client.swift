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
    
    func requestAirTraffic(completion: @escaping (_ traffic: AirTrafficResponse?, _ error: Error?) -> Void) {
        let request = Router.airTraffic
        Alamofire.request(request).responseObject { (response: DataResponse<AirTrafficResponse>) in
            switch response.result {
            case .success(let value):
                completion(value, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func confirmDelivery(droneID: String, completion: @escaping (_ error: Error?) -> Void) {
        let parameters: Parameters = [
            "userId": 1,
            "droneId": droneID
        ]
        let request = Router.confirmDelivery(parameters)
        Alamofire.request(request).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let val = value as? [String: String], let key = val["result"], key == "success" {
                    completion(nil)
                } else {
                    completion(NSError(domain: "", code: -1, userInfo: nil))
                }
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func requestDrone(start: GeoLocation, end: GeoLocation, traffic: AirTrafficResponse, completion: @escaping (_ key: String?, _ error: Error?) -> Void) {
        let parameters: Parameters = [
            "traffic": traffic.toJSON(),
            "drone": [
                "start": start.toJSON(),
                "end": end.toJSON(),
            ]
        ]
        let request = Router.requestDrone(parameters)
        Alamofire.request(request).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let val = value as? [String: String], let key = val["key"] {
                    completion(key, nil)
                } else {
                    completion(nil, NSError(domain: "", code: -1, userInfo: nil))
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
