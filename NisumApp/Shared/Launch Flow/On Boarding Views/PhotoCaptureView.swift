//
//  PhotoCaptureView.swift
//  Nisumapp (iOS)
//
//  Created by pnarayana on 08/02/22.
//  Copyright © 2022 Nisum. All rights reserved.
//

import SwiftUI

struct PhotoCaptureView: View {
    
    @Binding var showImagePicker: Bool
    @Binding var pickedImage: UIImage?
    var body: some View {
        ImagePicker(isShown: $showImagePicker, pickedImage: $pickedImage)
    }
}

struct PhotoCaptureView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoCaptureView(showImagePicker: .constant(false), pickedImage: .constant(UIImage(contentsOfFile: "")))
    }
}
