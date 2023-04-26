//
//  BaseServiceRequest.swift
//  Nisumapp (iOS)
//
//  Created by nisum on 27/12/21.
//  Copyright © 2021 Nisum. All rights reserved.
//

import Foundation
import UIKit

open class BaseServiceRequest<T: Decodable>: RequestEndPoint {
    
    public typealias Response = T
    
    public init(){}
    
    open var environment: NetworkEnvironment {
        return  NetworkEnvironment.development
    }
    
    open var baseCloudURL: String {
//        switch environment {
//        case .development : return "http://localhost:8080"
//        case .qa : return "http://localhost:8080"
//        case .staging : return "http://localhost:8080"
//        case .production : return "http://localhost:8080"
//        }
        
        switch environment {
        case .development : return "http://52.230.26.33:9090"
        case .qa : return "http://localhost:8080"
        case .staging : return "http://localhost:8080"
        case .production : return "http://localhost:8080"
        }
    }
    
    open var baseURL: URL {
        guard let url = URL(string: baseCloudURL) else
        {fatalError("baseURL could not be configured.")}
        return url
    }
    
    open var path: String {
        return ""
    }
    
    open var headers: NetworkHeaderInfo? {
        return NetworkHeaderInfo(with: environment, parameters: ["authorization": "network.authentication".localized + UserDefaultsManager.shared.getStringValue(forKey: "Token")])
    }
    
    open var httpMethod: HTTPMethod {
        return .get
    }
    
    open var task: HTTPTask {
        return .requestParametersAndHeaders(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: nil, additionHeaders: true)
    }
    
    open func decode(_ data: Data) throws -> Response {
        guard let responseModel = try? JSONDecoder().decode(BaseServiceResponseModel.self, from: data) else {
            return BaseServiceResponseModel(data: "") as! BaseServiceRequest<T>.Response
        }
        return responseModel as! BaseServiceRequest<T>.Response
    }
}

extension BaseServiceRequest {
    open func parameterToJson(parameters: [String: String]) -> String{
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(parameters) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        }
        return ""
    }
    
    open func generateBoundaryString() -> String{
        return "\(NSUUID().uuidString)"
    }
}
