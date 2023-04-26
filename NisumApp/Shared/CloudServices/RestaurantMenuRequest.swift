//
//  RestaurantMenuRequest.swift
//  Nisumapp (iOS)
//
//  Created by nisum on 06/01/22.
//  Copyright © 2022 Nisum. All rights reserved.
//

import Foundation
import NisumNetwork

class RestaurantMenuRequest<T: Decodable>: BaseServiceRequest<T> {
    
    typealias Response = T
    
    var restaurantID: String
    
    init(_ resID: String) {
        self.restaurantID = resID
        super.init()
    }
    
    override var path: String {
        return "/api/restaurant/data/" + self.restaurantID
    }
    
    override var httpMethod: HTTPMethod {
        return .get
    }
    
    override var task: HTTPTask {
        return .requestParametersAndHeaders(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: nil, additionHeaders: true)
    }
    
    override func decode(_ data: Data) throws -> Response {
        guard let responseModel = try? JSONDecoder().decode(MenuItems.self, from: data) else {
            return MenuItems(restaurant: Restaurant(restaurantID: "", restaurantName: "", restaurantDescription: "", address: "", managerName: "", phoneNo: "", cuisineType: "", email: "", zipCode: "", imageURL: "", timings: [], reasonList: [], contactInfo: ContactInfo(restaurantEmail: "", restaurantWebsite: "", restaurantPhone: "", facebookHandle: "", twitterHandle: nil), services: [], qrCode: "", geoLocation: GeoLocation(longitude: 0.0, latitude: 0.0), latitude: 0.0, longitude: 0.0, status: nil), menuDataList: []) as! RestaurantMenuRequest<T>.Response

        }
        return responseModel as! RestaurantMenuRequest<T>.Response
    }
}
