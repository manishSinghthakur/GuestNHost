//
//  RestaurantRequest.swift
//  Nisumapp (iOS)
//
//  Created by pnarayana on 05/01/22.
//  Copyright © 2022 Nisum. All rights reserved.
//

import Foundation
import NisumNetwork

class RestaurantRequest<T: Decodable>: BaseServiceRequest<T> {
    
    typealias Response = T
    var searchBy:SearchOption?
    var searchValue:String = ""
    var restaurantIdd:String = ""
    init(_ searchBy: SearchOption?, searchValue:String,restarantId:String){
        self.searchBy = searchBy
        self.searchValue = searchValue
        self.restaurantIdd = restarantId
    }
    override var path: String {
        var requestPath = ""
        if restaurantIdd.count > 0 {
            requestPath = "/api/restaurant/id/\(restaurantIdd)"
        } else {
        switch(searchBy){
        case .byName :
            requestPath = String("\("api.restaurant.searchBy.name".localized)restaurantName=\(self.searchValue)")

        case .byCuisine :
            requestPath = String("\("api.restaurant.searchBy.cuisine".localized)cuisineType=\(self.searchValue)")
        case .byMisc :
            requestPath = String("\("api.restaurant.searchBy.misc".localized)searchString=\(self.searchValue)")
        default :
            requestPath = String("\("api.restaurant.searchBy.name".localized)restaurantName=\(self.searchValue)")
        }
     }
        return requestPath.removingPercentEncoding!
    }
    
    override var headers: NetworkHeaderInfo? {
        let boundary = self.generateBoundaryString()
        return NetworkHeaderInfo(with: environment, parameters: ["authorization": "network.authentication".localized + UserDefaultsManager.shared.getStringValue(forKey: "Token"), "Content-Type": "multipart/form-data; boundary=\(boundary)"])
    }
    
    override var httpMethod: HTTPMethod {
        return .post
    }
    
    override var task: HTTPTask {
        let currentProfile : ProfileModel = DataManager.shared.getProfile()
        let parameters = ["id":currentProfile.id, "nickName": currentProfile.nickName,"city": currentProfile.city,"country": currentProfile.countryDescirption,"state": (currentProfile.countryCode == "CA" || currentProfile.countryCode == "US") ? currentProfile.provincesCode : currentProfile.provincesDescription ,"notificationToken": ""]
        return .requestMultiPartUpload(bodyParameters: ["profile": self.parameterToJson(parameters: parameters)], bodyEncoding: .multipartAndJsonEncoding, imageParameters: [:], additionHeaders: true)
        
    }
    
    override func decode(_ data: Data) throws -> Response {
        guard let responseModel = try? JSONDecoder().decode(RestaurantModel.self, from: data) else {
            print("Restaurant Response decode fails")
            return RestaurantModel(registeredRestaurants: [], restaurantsFromGoogle: []) as! RestaurantRequest<T>.Response
        }
        return responseModel as! RestaurantRequest<T>.Response
    }
}
