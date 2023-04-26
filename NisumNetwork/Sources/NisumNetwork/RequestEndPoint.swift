//
//  RequestEndPoint.swift
//  
//
//  Created by nisum on 23/09/21.
//

import Foundation

//  MARK: - Protocol
public protocol RequestEndPoint {
    
    associatedtype Response
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: NetworkHeaderInfo? { get }
    func decode(_ data: Data) throws -> Response
}

extension RequestEndPoint where Response: Decodable {
    func decode(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}
