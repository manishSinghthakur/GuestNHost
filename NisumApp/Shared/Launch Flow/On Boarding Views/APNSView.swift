//
//  APNSView.swift
//  Nisumapp (iOS)
//
//  Created by sboju on 10/13/21.
//  Copyright © 2021 Nisum. All rights reserved.
//

import SwiftUI

struct APNSView: View {
    @EnvironmentObject var appSetings:AppSettings
    
    var body: some View {
        VStack(alignment:.leading, spacing: 20.0) {
            BasicHeaderView(title: "setup.apns.title".localized, subtitle: "setup.apns.subtitle".localized)
            BasicCenterView()
            BasicFooterView(actionTitle: "setup.apns.turnon".localized, skipTitle: "setup.apns.skip".localized, action:{self.getAPNSPermission()}, skip: {self.screenCompleted()})
        }
        .padding(20.0)
        .background(Color.secondarySystemBackground)
        .edgesIgnoringSafeArea(.all)
    }
    
    func getAPNSPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { granted, error in
            guard granted else {
                self.screenCompleted()
                return
            }
            DataManager.shared.execute(asGroup: {UIApplication.shared.registerForRemoteNotifications()}) {
                self.screenCompleted()
            }
        }
    }
    
    func screenCompleted() {
        DispatchQueue.main.async {
            self.appSetings.screenState = .completedAPNS
            DataManager.shared.setAppSettings(as: self.appSetings)
        }
    }
}

struct APNSView_Previews: PreviewProvider {
    static var previews: some View {
        APNSView()
    }
}

