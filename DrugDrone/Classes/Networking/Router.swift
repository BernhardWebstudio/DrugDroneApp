//
//  Router.swift
//  DrugDrone
//
//  Created by Michal Švácha on 15/09/2018.
//  Copyright © 2018 Michal Švácha. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    static let baseURLString = "https://us-central1-drugdronefirebase.cloudfunctions.net"
    static let airTrafficURL = "https://hackzurich.involi.live/http/"
    static let axaURL = "https://health.axa.ch/hack/api"
    static let axaAPIKey = "talented test"
    
    case careProviders(Parameters)
    case takePill
    
    case airTraffic
    
    case requestDrone(Parameters)
    case confirmDelivery(Parameters)
    
    var baseURL: String {
        switch self {
        case .careProviders, .takePill:
            return Router.axaURL
        case .airTraffic:
            return Router.airTrafficURL
        default:
            return Router.baseURLString
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .careProviders, .airTraffic, .confirmDelivery:
            return .get
        case .takePill, .requestDrone:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .careProviders:
            return "care-providers"
        case .takePill:
            return "pharmacy/buy"
        case .requestDrone:
            return "requestDrone"
        case .confirmDelivery:
            return "confirmDrone"
        case .airTraffic:
            return ""
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: baseURL)!
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .careProviders(let parameters), .confirmDelivery(let parameters):
            urlRequest.setValue(Router.axaAPIKey, forHTTPHeaderField: "Authorization")
            return try Alamofire.URLEncoding.queryString.encode(urlRequest, with: parameters)
        case .takePill:
            urlRequest.setValue(Router.axaAPIKey, forHTTPHeaderField: "Authorization")
            return try Alamofire.URLEncoding.queryString.encode(urlRequest, with: nil)
        case .requestDrone(let parameters):
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
        case .airTraffic:
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            return try Alamofire.URLEncoding.queryString.encode(urlRequest, with: [:])
        }
    }
}
