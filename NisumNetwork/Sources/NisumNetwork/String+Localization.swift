//
//  String+Localization.swift
//  NisumNetworkManager
//
//  Created by nisum on 29/09/21.
//

import Foundation

// MARK: - String+Localization

///String extension for localization.
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    public func localized(with arguments: [CVarArg]) -> String {
        return String(format: self.localized, locale: nil, arguments: arguments)
    }
}

///Dictionary extension for merge two dictionary.
extension Dictionary {
    mutating func merge(_ dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
