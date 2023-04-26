//
//  LocationView.swift
//  Nisumapp (iOS)
//
//  Created by sboju on 10/13/21.
//  Copyright © 2021 Nisum. All rights reserved.
//

import SwiftUI

struct LocationView: View {
    @EnvironmentObject var appSetings:AppSettings
    @StateObject var locationManager:LocationManager = LocationManager()

    var body: some View {
        VStack(alignment:.leading, spacing: 20.0) {
            BasicHeaderView(title: "setup.location.title".localized, subtitle: "setup.location.subtitle".localized)
            BasicCenterView()
            BasicFooterView(actionTitle: "setup.location.turnon".localized, skipTitle: "setup.location.skip".localized, action: { self.getLocationPermission() }, skip: { self.screenCompleted() })
        }
        .padding(20.0)
        .background(Color.secondarySystemBackground)
        .edgesIgnoringSafeArea(.all)
    }
    
    func getLocationPermission() {
        DataManager.shared.execute(asGroup: { self.locationManager.requestAuthorisation() }) {
            self.screenCompleted()
        }
    }

    func screenCompleted() {
        DispatchQueue.main.async {
            self.appSetings.screenState = .completedLocation
            DataManager.shared.setAppSettings(as: self.appSetings)
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}
