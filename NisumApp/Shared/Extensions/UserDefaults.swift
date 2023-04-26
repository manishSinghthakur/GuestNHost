//
//  UserDefaults.swift
//  Nisumapp (iOS)
//
//  Created by sboju on 10/13/21.
//  Copyright © 2021 Nisum. All rights reserved.
//

import Foundation
import NisumNetwork

extension UserDefaultsManager {
    func getAppSettings()->AppSettings {
        let appSettings:AppSettings = defaults.codable(forKey: "appSettings") ?? AppSettings()
        return appSettings
    }
    
    func setAppSettings(appSettings:AppSettings) {
        defaults.set(value: appSettings, forKey: "appSettings")
    }
}
