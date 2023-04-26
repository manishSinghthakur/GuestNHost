////
////  File.swift
////  Nisumapp (iOS)
////
////  Created by Ratcha Mahesh Babu on 07/02/22.
////  Copyright © 2022 Nisum. All rights reserved.
////
//

import Foundation
import NisumNetwork

class RestaurantLocationSelectionRequest<T: Decodable>: BaseServiceRequest<T> {
    
    typealias Response = T
    
    var selectionPath: String
    
    init(_ pathSelection: String) {
        self.selectionPath = pathSelection
        super.init()
    }
    
    override var path: String {
        return "api/restaurant/\(selectionPath)"
    }
    
    override var httpMethod: HTTPMethod {
        return .get
    }
    
    override var task: HTTPTask {
        return .requestParametersAndHeaders(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: nil, additionHeaders: true)
    }

    override func decode(_ data: Data) throws -> Response {
        guard let responseModel = try? JSONDecoder().decode(ResturantCountriesResponceModel.self, from: data) else {
            return ResturantCountriesResponceModel( id: "", country: []) as! RestaurantLocationSelectionRequest<T>.Response
        }
        
//        guard let responseModel = try? JSONDecoder().decode(MenuItems.self, from: data) else {
//            return MenuItems(restaurant: Restaurant(restaurantID: "", restaurantName: "", restaurantDescription: "", address: "", managerName: "", cuisineType: "", email: "", reason: "", imageURL: "", timings: [], reasonList: [], contactInfo: Contact(restaurantEmail: "", restaurantWebsite: nil, restaurantPhone: "", facebookHandle: "", twitterHandle: ""), services: [], qrCode: "", geoLocation: GeoLocation(longitude: 0.0, latitude: 0.0), latitude: 0.0, longitude: 0.0, status: ""), menuDataList: []) as! RestaurantMenuRequest<T>.Response
//        }
        return responseModel as! RestaurantLocationSelectionRequest<T>.Response
    }
    
}
