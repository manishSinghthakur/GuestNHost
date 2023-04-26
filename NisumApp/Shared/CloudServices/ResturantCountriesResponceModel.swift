//
//  ResturantCountriesResponceModel.swift
//  Nisumapp (iOS)
//
//  Created by Ratcha Mahesh Babu on 07/02/22.
//  Copyright © 2022 Nisum. All rights reserved.
//


import Foundation

struct ResturantCountriesResponceModel: Codable {
    let id: String
    let country: [Country]
}

// MARK: - Country
struct Country: Codable {
    let countryName, countryCode: String
    let statess: [Statess]
}

// MARK: - Statess
struct Statess: Codable {
    let name: String
    let code: String?
}
