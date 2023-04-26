//
//  GuestView.swift
//  Nisumapp (iOS)
//
//  Created by sboju on 9/29/21.
//  Copyright © 2021 Nisum. All rights reserved.
//

import SwiftUI
import NisumNetwork
@frozen
enum SearchOption:Int, CaseIterable, Codable {
    case byName   = 0
    case byCuisine = 1
    case byMisc   = 2
    
    var title:String {
        switch self {
        case .byName:       return "find.restaurant.byname".localized
        case .byCuisine:    return "find.restaurant.bycuisine".localized
        case .byMisc:       return "find.restaurant.bymisc".localized
        }
    }
}


struct FindView: View {
    @State private var searchBy = SearchOption.byName
    @State private var isShowScanner = false
    
    @State var qrCode = QRCode(qrString: "")
    @State var searchText = ""
    @ObservedObject var viewModel :RestaurantViewModel
    var selectedSearchOption:SearchOption = SearchOption.byName
    init() {
        self.viewModel = RestaurantViewModel(SearchOption.byName, searchValue: "",restaurantId: "")
    }
    
    var body: some View {
        NavigationView {
            VStack() {
                Picker("Search By", selection: $searchBy) {
                    ForEach(SearchOption.allCases,id:\.self) {
                        Text($0.title)
                    }
                }
                .onChange(of: searchBy) { _ in
                    self.viewModel.searchRestaurantsByOption(SearchOption.byName, searchText: "")
                    self.searchText = ""
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 10)
                SearchBarView(text: $searchText, searchBy:$searchBy, viewModel: viewModel)

                if self.viewModel.loadingState == .loading {
                        Text("Loading...")
                }else if self.viewModel.loadingState == .failed {
                    Text("Failed...")
                    Button(action: {
                        UserDefaultsManager.shared.setStringValue(forKey: "Token", value: "")
                        let authRequest = AuthenticationRequest<AuthenticationResponseModel>()
                        NetworkManager.shared.request(authRequest, screenName: "Token Authentication", action: "Login") { result in
                            switch result {
                            case .success(_):
                                self.viewModel.searchRestaurantsByOption(SearchOption.byName, searchText: "")

                            case .failure(let error):
                                print(error.errorDescription ?? "")
                            }
                        }
                    }) {
                        Text("Reload Again")
                    }
                }
                Form {
                    if self.viewModel.loadingState == .success {
                        
                        if viewModel.registeredRestaurants.count == 0 && viewModel.nearByRestaurants.count == 0{
                            Text("No Results Found...")
                        }else{
                            
                            if viewModel.registeredRestaurants.count > 0{
                                Section(header: Text("find.restaurant.known".localized).font(.headline)){
                                    List(viewModel.registeredRestaurants, id:\.self){ knownRestaurant in
                                        RestaurantView(restaurant: knownRestaurant, showMenu: true)
                                    }
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                }
                                    ._automaticPadding(EdgeInsets(top: -30, leading: 0, bottom: 0, trailing: 0))
                            }
                            
                            if viewModel.nearByRestaurants.count > 0{
                                Section(header: Text("find.restaurant.nearby".localized).font(.headline)){
                                    List(viewModel.nearByRestaurants, id:\.self){ nearbyRestaurant in
                                        RestaurantFromGoogleView(restaurant:nearbyRestaurant , showMenu: true).padding(.vertical, 5)
                                    }
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                }  ._automaticPadding(EdgeInsets(top: -30, leading: 0, bottom: 0, trailing: 0))
                            }
                        }
                    }
                }   .padding(EdgeInsets(top: -5, leading: 0, bottom: -90, trailing: 0))

                .listStyle(GroupedListStyle())
                .background(Color.clear)
                
//                Spacer(minLength: 10.0)
            }
            .sheet(isPresented: $isShowScanner,onDismiss: {
                viewModel.searchRestaurantsById(.byName, restaurantId: "61df40e50c3aa859f84ae80b")
                
            }, content: {
                QRCodeCameraView(qrCode: $qrCode)
                // FilterView(filter: $filter, qrCode: $qrCode)
            })
            .navigationTitle("tab.find.title".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowScanner = true
                        
                    }) {
                        Image(systemName: "qrcode.viewfinder")
                    }
                }
            }
        }.background(Color.blue)
        .navigationBarHidden(true)
    }
}

struct QRCode {
    var qrString:String
}
