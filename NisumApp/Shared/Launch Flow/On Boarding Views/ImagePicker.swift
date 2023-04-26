//
//  ImagePicker.swift
//  Nisumapp (iOS)
//
//  Created by pnarayana on 08/02/22.
//  Copyright © 2022 Nisum. All rights reserved.
//

import Foundation
import SwiftUI

class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var isShown: Bool
    @Binding var pickedImage: UIImage?
    
    init(isShown: Binding<Bool>, pickedImage:Binding<UIImage?>) {
        _isShown = isShown
        _pickedImage = pickedImage
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        pickedImage = uiImage
        print("PickedImage Size : \(String(describing: pickedImage?.pngData()?.count))")
        ImageCompressor.compress(image: uiImage, maxByte: 200000) { image in
            guard let compressedImage = image else { return }
            self.pickedImage = compressedImage
            print("CompressedImage Size : \(String(describing: compressedImage.pngData()?.count))")
            
            if let pngRepresentation = compressedImage.pngData() {
                
                UserDefaults.standard.set(pngRepresentation, forKey: "currentImage")
            }

        }
        
        isShown = false
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
    
}

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var isShown: Bool
    @Binding var pickedImage: UIImage?
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> ImagePickerCoordinator {
        return ImagePickerCoordinator(isShown: $isShown, pickedImage: $pickedImage)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
}
