//
//  DefaultsManager.swift
//  Nisumapp (iOS)
//
//  Created by sboju on 10/18/21.
//  Copyright © 2021 Nisum. All rights reserved.
//

import Foundation
import NisumNetwork
import UIKit
//  MARK: - Base Class
class DefaultsManager {
    
    //  MARK: - Properties
    private var userDefaultsManager:UserDefaultsManager
    private let keyProfileName:String = "profileName"
    private let keyCity:String = "city"
    private let keyCountry:String = "country"
    private let keyCountryDescription:String = "countryDescription"
    private let keyState:String = "state"
    private let keyProvincesCode = "provincesCode"
    private let keyId:String = "id"
    private let keyImageUrl:String = "imageUrl"
    private let keyImageData:String = "imageData"
    private let keyProfileImage:String = "profileImage"
    private let keyDeviceToken:String = "deviceToken"
    
    private var appSettings:AppSettings
    
    //  MARK: - Life Cycle
    init() {
        self.userDefaultsManager = UserDefaultsManager()
        self.appSettings = userDefaultsManager.getAppSettings()
    }
    
    //  MARK: - App State
    func getAppSettings()->AppSettings {
        return appSettings
    }
    
    func setAppSettings(as appSettings:AppSettings) {
        userDefaultsManager.setAppSettings(appSettings: appSettings)
    }
    
    //  MARK: - Helper Methods
    func saveDeviceToken(as token:String) {
        userDefaultsManager.defaults.set(token, forKey: keyDeviceToken)
    }
    
    func saveProfile(as profile:ProfileModel) {
        userDefaultsManager.defaults.set(profile.nickName, forKey: keyProfileName)
        userDefaultsManager.defaults.set(profile.city, forKey: keyCity)
        userDefaultsManager.defaults.set(profile.provincesDescription, forKey: keyState)
        userDefaultsManager.defaults.set(profile.provincesCode, forKey: keyProvincesCode)
        userDefaultsManager.defaults.set(profile.id, forKey: keyId)
        userDefaultsManager.defaults.set(profile.imageUrl, forKey: keyImageUrl)
        if let profileImage = profile.profileImage {
            userDefaultsManager.setData(forKey: keyProfileImage, value: profileImage.pngData() as Any)
        }
        userDefaultsManager.defaults.set(profile.countryCode, forKey: keyCountry)
        userDefaultsManager.defaults.set(profile.countryDescirption, forKey: keyCountryDescription)
    }
    
    func getProfile()->ProfileModel {
        let profile:ProfileModel = ProfileModel()
        profile.nickName = userDefaultsManager.getStringValue(forKey: keyProfileName)
        profile.city = userDefaultsManager.getStringValue(forKey: keyCity)
        profile.provincesDescription = userDefaultsManager.getStringValue(forKey: keyState)
        if let imageData = userDefaultsManager.getData(forKey: keyProfileImage){
            profile.profileImage  = UIImage(data: imageData as Data)
        }
        profile.provincesCode = userDefaultsManager.getStringValue(forKey: keyProvincesCode)
        profile.id = userDefaultsManager.getStringValue(forKey: keyId)
        profile.imageUrl = userDefaultsManager.getStringValue(forKey: keyImageUrl)
        profile.countryCode = userDefaultsManager.getStringValue(forKey: keyCountry)
        profile.countryDescirption = userDefaultsManager.getStringValue(forKey: keyCountryDescription)
        profile.deviceToken = userDefaultsManager.getStringValue(forKey: keyDeviceToken)
        return profile
    }
}
