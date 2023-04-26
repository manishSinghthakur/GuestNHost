//
//  RestaurantViewModel.swift
//  Nisumapp (iOS)
//
//  Created by pnarayana on 05/01/22.
//  Copyright © 2022 Nisum. All rights reserved.
//

import Foundation


import Foundation
import MapKit
import NisumNetwork
class RestaurantViewModel:BaseViewModel {
    @Published var registeredRestaurants = [RegisteredRestaurant]()
    @Published var nearByRestaurants = [RestaurantsFromGoogle]()
    
    var searchBy:SearchOption? = .byName
    var searcchValue:String = ""
    var restarantIdd:String = ""
    init(_ searchBy:SearchOption, searchValue:String, restaurantId:String) {
        super.init()
        self.searchBy = searchBy
        self.searcchValue =  searchValue
        self.restarantIdd = restaurantId
        getAllRestaurant(searchBy: searchBy, searchValue: searcchValue, resturentId: restaurantId)
    }
    //  MARK: - All Restaurants
    func getAllRestaurant(searchBy:SearchOption, searchValue:String, resturentId: String){
        let restaurantRequest1 = RestaurantRequest<RestaurantModel>(searchBy, searchValue: searchValue, restarantId: resturentId)
        self.loadingState = .loading
        NetworkManager.shared.request(restaurantRequest1, screenName: "RestaurnatList", action: "Restaurant List") { [self] result in
            switch result {
            case .success(let response):
                print(response)
                DispatchQueue.main.async {
                    self.loadingState = .success
                    self.registeredRestaurants = response.registeredRestaurants
                    self.nearByRestaurants = response.restaurantsFromGoogle
                }

            case .failure(let error):
                DispatchQueue.main.async {
                    self.loadingState = .failed
                }
                print("Restaurant List response failed")
                print(error.errorDescription ?? "")
            }
        }
    }
    
    //  MARK: - Restaurants By SearchOption
    func searchRestaurantsByOption(_ by:SearchOption, searchText:String){
        let restaurantRequest = RestaurantRequest<RestaurantModel>(by, searchValue: searchText, restarantId: "")
        self.loadingState = .loading
        NetworkManager.shared.request(restaurantRequest, screenName: "RestaurnatList", action: "Restaurant List") { [self] result in
            switch result {
            case .success(let response):
               // print(response)
                DispatchQueue.main.async {
                    self.loadingState = .success
                    self.registeredRestaurants = response.registeredRestaurants
                    self.nearByRestaurants = response.restaurantsFromGoogle
                }

            case .failure(let error):
                print("Restaurant List response failed")
                DispatchQueue.main.async {
                    self.loadingState = .failed
                }
                print(error.errorDescription ?? "")
            }
        }
    }

    //  MARK: - Restaurants By Id
    func searchRestaurantsById(_ by:SearchOption, restaurantId:String){
        let restaurantRequest = RestaurantRequest<RestaurantModel>(by, searchValue: "", restarantId: restaurantId)
        self.loadingState = .loading
        NetworkManager.shared.request(restaurantRequest, screenName: "RestaurnatList", action: "Restaurant List") { [self] result in
            switch result {
            case .success(let response):
                print(response)
                DispatchQueue.main.async {
                    self.loadingState = .success
                    self.registeredRestaurants = response.registeredRestaurants
                    self.nearByRestaurants = response.restaurantsFromGoogle
                }

            case .failure(let error):
                print("Restaurant List response failed")
                self.loadingState = .failed
                print(error.errorDescription ?? "")
            }
        }
    }
}
