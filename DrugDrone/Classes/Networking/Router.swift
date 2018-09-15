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
    static let baseURLString = ""
    static let axaURL = "https://health.axa.ch/hack/api"
    static let axaAPIKey = "talented test"
    
    case careProviders(Parameters)
    case takePill
    
    var baseURL: String {
        switch self {
        case .careProviders, .takePill:
            return Router.axaURL
        default:
            return Router.baseURLString
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .careProviders:
            return .get
        case .takePill:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .careProviders:
            return "care-providers"
        case .takePill:
            return "pharmacy/buy"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: baseURL)!
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .careProviders(let parameters):
            urlRequest.setValue(Router.axaAPIKey, forHTTPHeaderField: "Authorization")
            return try Alamofire.URLEncoding.queryString.encode(urlRequest, with: parameters)
        case .takePill:
            urlRequest.setValue(Router.axaAPIKey, forHTTPHeaderField: "Authorization")
            return try Alamofire.URLEncoding.queryString.encode(urlRequest, with: nil)
        }
    }
}
