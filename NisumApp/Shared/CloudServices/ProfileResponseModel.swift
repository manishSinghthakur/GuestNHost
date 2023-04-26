//
//  ProfileResponseModel.swift
//  Nisumapp (iOS)
//
//  Created by nisum on 23/12/21.
//  Copyright © 2021 Nisum. All rights reserved.
//

import Foundation


struct ProfileResponseModel: Codable {
    
    // MARK: - Properties
    let id, nickName, city, state, country: String
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id, nickName, city, state, country
        case imageURL = "imageUrl"
    }
}
