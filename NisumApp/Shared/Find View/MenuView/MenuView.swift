//
//  MenuView.swift
//  Nisumapp (iOS)
//
//  Created by nisum on 04/01/22.
//  Copyright © 2022 Nisum. All rights reserved.
//

import Foundation
import SwiftUI

struct MenuView: View {
    @ObservedObject var viewModel = MenuViewModel()
    var restaurantID: String
    var restaurantName: String
    var image = UIImage(named: "swift-logo")
    @State var scale: CGFloat = 1.0
    @State var lastScaleValue: CGFloat = 1.0
    var body: some View {
        //        ScrollView([.vertical, .horizontal], showsIndicators: false){
        //            ZStack{
        //                Rectangle().foregroundColor(.clear).frame(width: image!.size.width * scale, height: image!.size.height * scale, alignment: .center)
        //                Image(uiImage: image!).scaleEffect(scale)
        //                    .gesture(MagnificationGesture().onChanged { val in
        //                        let delta = val / self.lastScaleValue
        //                        self.lastScaleValue = val
        //                        var newScale = self.scale * delta
        //                        if newScale < 1.0 {
        //                            newScale = 1.0
        //                        }
        //                        scale = newScale
        //                    }.onEnded{val in
        //                        lastScaleValue = 1
        //                    })
        //            }
        //        }.background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        
        List {
            ForEach(viewModel.menuList) { menuItemList in
                ForEach(menuItemList.categoryList!) { restCategoryList in
                    Section(header: Text(restCategoryList.category?.categoryName ?? "")) {
                        if let categoryList = restCategoryList.itemData, categoryList.count > 0 {
                            ForEach(restCategoryList.itemData!) { itemList in
                                ForEach(itemList.recipeBOS ?? []) { item in
                                    MenuItemView(menuItem: item)
                                }
                            }
                        }else{
                            ForEach(restCategoryList.recipeBOS ?? []) { item in
                                MenuItemView(menuItem: item)
                            }
                        }
                    }
                }
            }
        } .onAppear {
            self.viewModel.getRestaurantMenu(restaurantID)
        }.navigationTitle(restaurantName)
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct RestaurantMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(restaurantID: "", restaurantName: "")
    }
}
