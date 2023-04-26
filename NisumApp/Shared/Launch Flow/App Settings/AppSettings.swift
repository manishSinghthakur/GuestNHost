//
//  AppSettings.swift
//  Nisumapp (iOS)
//
//  Created by sboju on 10/13/21.
//  Copyright © 2021 Nisum. All rights reserved.
//

import Foundation

class AppSettings: Codable, ObservableObject {
    @Published var screenState:OnBoardingScreenState    = .unknown
    @Published var profileState:OnBoardingProfileState  = .unknown
    
    init() {}
    
    enum CodingKeys: CodingKey {
        case screenState
        case profileState
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(screenState, forKey: .screenState)
        try container.encode(profileState, forKey: .profileState)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        screenState = try container.decode(OnBoardingScreenState.self, forKey: .screenState)
        profileState = try container.decode(OnBoardingProfileState.self, forKey: .profileState)
    }
}
