//
//  SearchBarView.swift
//  Nisumapp (iOS)
//
//  Created by sboju on 9/29/21.
//  Copyright © 2021 Nisum. All rights reserved.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    @Binding var searchBy:SearchOption
    @State private var isEditing = false
    @ObservedObject var viewModel :RestaurantViewModel

    var body: some View {
        HStack {
            TextField("Search for restaurant", text: $text, onEditingChanged: {_ in
                print(text)
            }, onCommit: {
                print(text)
                viewModel.searchRestaurantsByOption(searchBy, searchText: text)
                self.isEditing = false

            })
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
 
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    viewModel.searchRestaurantsByOption(SearchOption.byName, searchText: "")
 
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}
