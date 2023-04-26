//
//  QRCodeFrame.swift
//  Nisumapp
//
//  Created by Mahesh on 07/01/22.
//  Copyright © 2022 Nisum. All rights reserved.
//

import UIKit

public struct QRCodeFrame {
    
    public let corners:[CGPoint]
    public let cameraPreviewView: UIView
    
    public func draw(lineWidth: CGFloat = 1, lineColor: UIColor = UIColor.red, fillColor: UIColor = UIColor.clear) {
        
        let view = cameraPreviewView as! QRCameraPreview
        
        view.drawFrame(corners: corners,
            lineWidth: lineWidth,
            lineColor: lineColor,
            fillColor: fillColor)
    }
    
    

}
