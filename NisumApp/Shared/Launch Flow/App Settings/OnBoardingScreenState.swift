//
//  OnBoardingScreenState.swift
//  Nisumapp (iOS)
//
//  Created by sboju on 10/13/21.
//  Copyright © 2021 Nisum. All rights reserved.
//

@frozen
enum OnBoardingScreenState:Int, CaseIterable, Codable {
    case completedNickName
    case completedAPNS
    case completedLocation
    case completedProfile
    case unknown
}
