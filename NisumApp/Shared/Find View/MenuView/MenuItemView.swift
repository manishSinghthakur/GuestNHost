//
//  MenuItemView.swift
//  Nisumapp (iOS)
//
//  Created by nisum on 05/01/22.
//  Copyright © 2022 Nisum. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

struct MenuItemView: View {
    var menuItem: RecipeBO?
    @State var itemValue: Int = 0
    @State var selectedColor: Color = .red
    
    var body: some View {
        HStack(spacing: 1.0) {
            VStack(alignment: .leading, spacing: 8, content:{
                if let menu = menuItem {
                Text(menu.recipeName)
                    .font(.headline)
                Text(menu.recipeBODescription).font(.subheadline)
                Text("₹ \(menu.price)")
                    .padding(.top, 2.0)
            }
            })
            Spacer(minLength: 10.0)
            VStack(alignment: .center, spacing: 1){
                Image("swift-logo")
                    .resizable()
                    .frame(maxWidth: 50.0, maxHeight: 50.0, alignment: .trailing)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                Spacer(minLength: 3.0)
                CheckBox(selectedColor: self.$selectedColor, itemValue: self.$itemValue, color: .green)
                    .frame(maxWidth: 80, maxHeight: 80, alignment: .trailing)
                Spacer(minLength: 5.0)
                HStack(alignment: .center, spacing: 1) {
                    Button(" - ", action: {
                        self.itemValue = self.itemValue == 0 ? 0 : self.itemValue - 1
                        self.selectedColor = self.itemValue == 0 ? .red : .green
                    }).buttonStyle(BorderlessButtonStyle())
                        .frame(minWidth: 40, maxWidth: 40, minHeight: 30)
                        .accentColor(Color.black)
                        .background(Color.systemGray4)
                    Spacer(minLength: 0.01)
                    Button(" + ", action: {
                        self.itemValue = self.itemValue + 1
                        self.selectedColor = .green
                    }).buttonStyle(BorderlessButtonStyle())
                        .frame(minWidth: 40, maxWidth: 40, minHeight: 30)
                        .accentColor(Color.black)
                        .background(Color.systemGray4)
                    
                }.frame(maxWidth: 80, maxHeight: 30)
                    .cornerRadius(5)
            }
        }
        .padding(.vertical, 10)
    }
}

struct MenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            MenuItemView(menuItem: nil).preferredColorScheme($0)
        }
    }
}

struct CheckBox: View {
    @Binding var selectedColor: Color
    @Binding var itemValue: Int
    var color: Color
    var body: some View {
        
        HStack(alignment: .center, spacing: 1) {
            Button {} label: {
                Image(systemName: itemValue == 0 ? "circle" : "circle" /* "checkmark.circle.fill"*/)
            }.frame(minWidth: 30, maxWidth: 30, minHeight: 20)
                .accentColor(self.selectedColor)
            Text(itemValue == 0 ? "" : "" /*"\(itemValue)"*/)
        }.frame(maxWidth: 80, maxHeight: 30)
    }
}
