//
//  Bundle.swift
//  Nisumapp (iOS)
//
//  Created by sboju on 10/12/21.
//  Copyright © 2021 Nisum. All rights reserved.
//

import Foundation

extension Bundle {
    var version: String {
        let dictionary = Bundle.main.infoDictionary!
        let version = String(describing: dictionary["CFBundleShortVersionString"] ?? "")
        let build = String(describing: dictionary["CFBundleVersion"] ?? "")
        return "Version \(version) (\(build))"
    }
}
