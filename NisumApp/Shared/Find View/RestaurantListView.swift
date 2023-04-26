//
//  RestaurantListView.swift
//  Nisumapp (iOS)
//
//  Created by pnarayana on 11/01/22.
//  Copyright © 2022 Nisum. All rights reserved.
//

import SwiftUI

struct RestaurantListView: View {
    let model: RestaurantViewModel
    var body: some View {
        if model.registeredRestaurants.count > 0{
            Section(header: Text("find.restaurant.known".localized))
            {
                List(model.registeredRestaurants, id:\.self){ knownRestaurant in
                    NavigationLink {
                        //RestaurantMenuView()
                    } label: {
                        RestaurantView(restaurant: knownRestaurant, showMenu: true)
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
        } else {
            Text("No Registered Restaurants Found...")
        }

        if model.nearByRestaurants.count > 0{
            Section(header: Text("find.restaurant.nearby".localized))
            {
                List(model.nearByRestaurants, id:\.self){ nearbyRestaurant in
                    NavigationLink {
                        //RestaurantMenuView()
                    } label: {
                        RestaurantFromGoogleView(restaurant:nearbyRestaurant , showMenu: true).padding(.vertical, 5)
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
        }else {
            Text("No NearBy Restaurants Found...")
        }
    }
}
