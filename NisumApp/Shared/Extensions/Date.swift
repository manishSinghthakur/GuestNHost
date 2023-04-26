//
//  Date.swift
//  Nisumapp (iOS)
//
//  Created by pnarayana on 12/01/22.
//  Copyright © 2022 Nisum. All rights reserved.
//

import Foundation

extension Date {
    
    //  MARK: - dayOfWeek
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
            //.capitalized
        // or use capitalized(with: locale) if you want
    }
    
}



