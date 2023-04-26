//
//  OnBoardingProfileState.swift
//  Nisumapp (iOS)
//
//  Created by sboju on 10/13/21.
//  Copyright © 2021 Nisum. All rights reserved.
//

@frozen
enum OnBoardingProfileState:Int, CaseIterable, Codable {
    case completedDeviceIdentifier
    case completedDeviceToken
    case completedDeviceLocation
    case completedProfile
    case unknown
}
