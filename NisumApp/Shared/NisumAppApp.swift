//
//  NisumappApp.swift
//  Shared
//
//  Created by sboju on 9/27/21.
//

import SwiftUI

@main
struct NisumappApp: App {
    let appSettings:AppSettings
    let dataManager:DataManager = DataManager.shared
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    init() {
        appSettings = dataManager.getAppSettings()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView().environmentObject(appSettings).environment(\.colorScheme, .light)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    let dataManager:DataManager = DataManager.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {return true}
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)          {
        dataManager.setDeviceToken(as: deviceToken.hexString)
        print(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
}
