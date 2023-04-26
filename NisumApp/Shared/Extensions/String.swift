//
//  String.swift
//  Nisumapp (iOS)
//
//  Created by sboju on 10/1/21.
//  Copyright © 2021 Nisum. All rights reserved.
//

import SwiftUI

extension String {
    public var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    public func localized(with arguments:CVarArg...) -> String {
        return String(format: localized, arguments: arguments)
    }
}

extension String: Identifiable {
    public var id: String {
        self
    }
}


