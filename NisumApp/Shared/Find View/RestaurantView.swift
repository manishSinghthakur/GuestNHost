//
//  RestaurantsView.swift
//  Nisumapp (iOS)
//
//  Created by sboju on 9/28/21.
//  Copyright © 2021 Nisum. All rights reserved.
//

import SwiftUI

struct RestaurantView: View {
    var restaurant:RegisteredRestaurant
    var showMenu:Bool = false
    @State var selection: Int? = nil
    
    var body: some View {
        HStack(spacing: 5.0) {
            VStack(alignment: .leading, spacing: 8, content: {
                Text(restaurant.restaurantName).font(.title3).foregroundColor(.label)
                Text(restaurant.address).font(.body).foregroundColor(.secondaryLabel)
                if let timingString = restaurant.getTiming(), timingString.count > 0{
                    Text(timingString).font(.subheadline).foregroundColor(.secondaryLabel)
                }
                Text(restaurant.cuisineType).font(.subheadline).foregroundColor(.secondaryLabel)
            }).padding(.horizontal, 0)
            Spacer(minLength: 10.0)
            VStack(alignment: .trailing, spacing: 1){
                if let path = restaurant.imageURL {
                    
                    if #available(iOS 15.0, *) {
                        
                        CacheAsyncImage(url: URL(string: path)!) { phase in
                            switch phase {
                            case .success(let image):
                                HStack {
                                    image
                                        .resizable()
//                                        .aspectRatio(contentMode: .fit)
                                        .scaledToFit()
                                        .frame(width: 100.0, height: 80.0)
                                        .cornerRadius(10)
                                }
                            @unknown default:
                                Image("swift-logo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100.0, height: 60.0)
                                    .cornerRadius(10)
                            }
                        }
                        /*
                         AsyncImage(url: URL(string: path)) { image in
                         image
                         .resizable()
                         .scaledToFit()
                         } placeholder: {
                         Color.purple.opacity(0.1)
                         }
                         .frame(width: 100.0, height: 60.0)
                         .cornerRadius(10)
                         .shadow(radius: 10)
                         */
                    } else {
                        Image(path)
                            .resizable()
                            .frame(width: 60.0, height: 60.0)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }
                    
                }
                Spacer(minLength: 5.0)
                HStack(alignment: .center, spacing: 1){
                    if showMenu == true {
                        NavigationLink(destination: MenuView(restaurantID: restaurant.restaurantID, restaurantName: restaurant.restaurantName), tag: 1, selection: $selection) {
                        }.opacity(0)
                            .background(
                                HStack(alignment: .center, spacing: 1) {
                                    Button("find.restaurant.menu".localized) {
                                        self.selection = 1
                                    }.foregroundColor(.red)
                                })
                    }
                }
            }
        }.padding(.vertical, 10)
    }
}

struct RestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            RestaurantView(restaurant:RegisteredRestaurant(restaurantID: "", restaurantName: "", address: "", cuisineType: "", imageURL: "", timings: [], contactInfo: ContactInfo(restaurantEmail: "", restaurantWebsite: nil, restaurantPhone: "", facebookHandle: "", twitterHandle:TwitterHandle(rawValue: "")), services: []) ).preferredColorScheme($0)
        }
    }
}


