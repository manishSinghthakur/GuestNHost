//
//  Data.swift
//  Nisumapp (iOS)
//
//  Created by nisum on 04/01/22.
//  Copyright © 2022 Nisum. All rights reserved.
//

import SwiftUI

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
