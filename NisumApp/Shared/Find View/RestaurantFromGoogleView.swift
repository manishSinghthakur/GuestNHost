//
//  RestaurantFromGoogleView.swift
//  Nisumapp (iOS)
//
//  Created by pnarayana on 05/01/22.
//  Copyright © 2022 Nisum. All rights reserved.
//

import SwiftUI

struct RestaurantFromGoogleView: View {
    var restaurant:RestaurantsFromGoogle
    var showMenu:Bool = false
    var body: some View {
        HStack(spacing: 10.0) {
            VStack(alignment: .leading, spacing: 10, content: {
                Text(restaurant.name).font(.title3).foregroundColor(.label).padding(.vertical, 5)
                Text(restaurant.address).font(.body).foregroundColor(.secondaryLabel).padding(.vertical, 5)
            })
            .padding(.horizontal, 0)
            .padding(.vertical, 5)
        }
    }
}

struct RestaurantFromGoogleView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantFromGoogleView(restaurant: RestaurantsFromGoogle(name: "Paradise", address: "Thoraipakkam, Chennai, India - 600097"))
    }
}
