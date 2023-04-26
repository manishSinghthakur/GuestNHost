//
//  RootView.swift
//  Nisumapp (iOS)
//
//  Created by sboju on 9/28/21.
//  Copyright © 2021 Nisum. All rights reserved.
//

import SwiftUI
import NisumNetwork

struct RootView: View {
    @EnvironmentObject var appSettings:AppSettings
    
    @ViewBuilder var body: some View {
        Group {
            if self.appSettings.screenState == .unknown {
                NickNameView()
            }
            else if self.appSettings.screenState == .completedNickName {
                APNSView()
            }
            else if self.appSettings.screenState == .completedAPNS {
                LocationView()
            }
            else if self.appSettings.screenState == .completedLocation {
                ProfileView()
            }
            else if self.appSettings.screenState == .completedProfile {
                MainView()
            }
        }
    }
}
