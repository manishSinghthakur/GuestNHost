//
//  QRCodeScanner1.swift
//  Nisumapp
//
//  Created by Mahesh on 07/01/22.
//  Copyright © 2022 Nisum. All rights reserved.
//

import SwiftUI
import AVFoundation



public struct QRCodeScanner: UIViewRepresentable {

    public typealias OnFound = (QRCodeData)->Void
    public typealias OnDraw = (QRCodeFrame)->Void
    
    public typealias UIViewType = QRCameraPreview
    
    @Binding
    public var supportBarcode: [AVMetadataObject.ObjectType]
    
    @Binding
    public var torchLightIsOn:Bool
    
    @Binding
    public var scanInterval: Double
    
    @Binding
    public var cameraPosition:AVCaptureDevice.Position
    
    @Binding
    public var mockBarCode: QRCodeData

    public let isActive: Bool
    
    public var onFound: OnFound?
    public var onDraw: OnDraw?
    
    public init(supportBarcode:Binding<[AVMetadataObject.ObjectType]> ,
         torchLightIsOn: Binding<Bool> = .constant(false),
         scanInterval: Binding<Double> = .constant(3.0),
         cameraPosition: Binding<AVCaptureDevice.Position> = .constant(.back),
         mockBarCode: Binding<QRCodeData> = .constant(QRCodeData(value: "barcode value", type: .qr)),
         isActive: Bool = true,
         onFound: @escaping OnFound,
         onDraw: OnDraw? = nil
    ) {
        _torchLightIsOn = torchLightIsOn
        _supportBarcode = supportBarcode
        _scanInterval = scanInterval
        _cameraPosition = cameraPosition
        _mockBarCode = mockBarCode
        self.isActive = isActive
        self.onFound = onFound
        self.onDraw = onDraw
    }
    
    public func makeUIView(context: UIViewRepresentableContext<QRCodeScanner>) -> QRCodeScanner.UIViewType {
        let view = QRCameraPreview()
        view.scanInterval = scanInterval
        view.supportBarcode = supportBarcode
        view.setupScanner()
        view.onFound = onFound
        view.onDraw = onDraw
        view.mockBarCode = mockBarCode
        return view
    }

    public static func dismantleUIView(_ uiView: QRCameraPreview, coordinator: ()) {
        uiView.session?.stopRunning()
    }

    public func updateUIView(_ uiView: QRCameraPreview, context: UIViewRepresentableContext<QRCodeScanner>) {
        
        uiView.setTorchLight(isOn: torchLightIsOn)
        uiView.setCamera(position: cameraPosition)
        uiView.scanInterval = scanInterval
        uiView.setSupportedBarcode(supportBarcode: supportBarcode)
        
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)

        if isActive {
            if !(uiView.session?.isRunning ?? false) {
                uiView.session?.startRunning()
            }
            uiView.updateCameraView()
        } else {
            uiView.session?.stopRunning()
        }
    }

}
