//
//  JSONParameterEncoder.swift
//  
//
//  Created by nisum on 23/09/21.
//

import Foundation

public struct JSONParameterEncoder: ParameterEncoder {
    public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
        }catch {
            throw NetworkError.encodingFailed
        }
    }
}

