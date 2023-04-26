//
//  AuthenticationRequest.swift
//  Nisumapp (iOS)
//
//  Created by nisum on 27/12/21.
//  Copyright © 2021 Nisum. All rights reserved.
//

import Foundation
import NisumNetwork
import UIKit
class AuthenticationRequest<T: Decodable>: BaseServiceRequest<T> {
    
    typealias Response = T
    
    override var path: String {
        return "/api/restaurant/authenticate"
    }
    
    override var httpMethod: HTTPMethod {
        return .post
    }
    
    override var task: HTTPTask {
        return .requestParametersAndHeaders(bodyParameters: [
            "username": "pnarayana@nisum",
            "password": "Reddy123"
        ], bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: true)
    }
    
    override func decode(_ data: Data) throws -> Response {
        guard let responseModel = try? JSONDecoder().decode(AuthenticationResponseModel.self, from: data) else {
            return AuthenticationResponseModel(jwt: "") as! AuthenticationRequest<T>.Response
        }
        UserDefaultsManager.shared.setStringValue(forKey: "Token", value: responseModel.jwt)
        return responseModel as! AuthenticationRequest<T>.Response
    }
}
