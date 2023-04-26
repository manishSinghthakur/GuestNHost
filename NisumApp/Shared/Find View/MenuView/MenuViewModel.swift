//
//  MenuViewModel.swift
//  Nisumapp (iOS)
//
//  Created by nisum on 04/01/22.
//  Copyright © 2022 Nisum. All rights reserved.
//

import Foundation
import NisumNetwork

class MenuViewModel: ObservableObject {
    @Published var menuList: [MenuDataList] = []
    
    func getRestaurantMenu(_ restaurantID: String) {
        let restRequest = RestaurantMenuRequest<MenuItems>(restaurantID)
        NetworkManager.shared.request(restRequest, screenName: "Restaurant Menu", action: "Restaurant List") { [weak self] result in
            switch result {
            case .success(let response):
                self?.updateRestaurantMenu(response.menuDataList)
            case .failure(let error):
                print(error.errorDescription ?? "")
            }
        }
    }
    
    func updateRestaurantMenu(_ menuItems: [MenuDataList]) {
        DispatchQueue.main.async {
            self.menuList = menuItems
        }
    }
}



