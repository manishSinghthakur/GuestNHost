//
//  MainView.swift
//  Nisumapp (iOS)
//
//  Created by sboju on 9/28/21.
//  Copyright © 2021 Nisum. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @State var selectedView = 1
    
    init() {
            UITabBar.appearance().backgroundColor = UIColor.white
        }
    
    var body: some View {
        TabView(selection: $selectedView) {
            FindView()
                .navigationTitle(Text("find.restaurant.title".localized))
            .tabItem {
                Label("tab.find.title".localized, systemImage:"magnifyingglass.circle.fill")
            }
            .tag(1)
            
            ProfileView()
                .navigationTitle(Text("setup.profile.title".localized))
            
            .tabItem {
                Label("tab.settings.title".localized, systemImage:"gearshape.fill")
            }
            .tag(2)
            
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
