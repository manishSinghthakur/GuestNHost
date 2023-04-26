//
//  QRCodeData.swift
//  Nisumapp
//
//  Created by Mahesh on 07/01/22.
//  Copyright © 2022 Nisum. All rights reserved.
//


import AVFoundation
import UIKit

public struct QRCodeData {
    public let value: String
    public let type: AVMetadataObject.ObjectType

    public init(value: String, type: AVMetadataObject.ObjectType) {
        self.value = value
        self.type = type
    }
    
}
