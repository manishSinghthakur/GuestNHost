//
//  DataManager.swift
//  Nisumapp (iOS)
//
//  Created by sboju on 10/13/21.
//  Copyright © 2021 Nisum. All rights reserved.
//

import Foundation
import NisumNetwork

//  MARK: - Class
class DataManager {
    //  MARK: - Properties
    static let shared = DataManager()
    var dataQueue = DispatchQueue(label: "com.datamanager.concurrent", qos: .background, attributes: .concurrent)
    private var userDefaultsManager:UserDefaultsManager
    private var defaultsManager:DefaultsManager
    //  MARK: - Life Cycle
    private init() {
        userDefaultsManager = UserDefaultsManager()
        defaultsManager = DefaultsManager()
    }
    
    //  MARK: - App State
    func getAppSettings()->AppSettings {
        return userDefaultsManager.getAppSettings()
    }
    
    func setAppSettings(as appSettings:AppSettings) {
        defaultsManager.setAppSettings(as: appSettings)
    }
    
    //  MARK: - Profile
    func setDeviceToken(as token:String) {
        defaultsManager.saveDeviceToken(as: token)
    }
    
    func setProfile(as profileModel:ProfileModel) {
        defaultsManager.saveProfile(as: profileModel)
    }
    
    func getProfile()->ProfileModel {
        return defaultsManager.getProfile()
    }
    
//    func enableFieldEditing()-> Bool {
//
//    }

    //  MARK: - Helper Methods
    func execute(asGroup firstBlock:@escaping ()-> Void, secondBlock:@escaping ()-> Void) {
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.main.async {
            firstBlock()
            group.leave()
        }
        
        group.notify(queue: .main) {
            secondBlock()
        }
    }
}
