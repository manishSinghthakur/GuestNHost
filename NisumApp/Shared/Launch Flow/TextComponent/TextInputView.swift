////
////  NickNameComponent.swift
////  Nisum_Components
////
////  Created by Ratcha Mahesh Babu on 06/12/21.
////
//


import SwiftUI

struct TextInputView: View {
    
    var prompt: String = ""
    var textInputParams:TextInputParameters
    @Binding var textfield :String
    var isSecure:Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack{
            if textInputParams.showLabel == true {
                Text(textInputParams.labelName).foregroundColor(Color.gray).font(.system(size: 14))
                Spacer()
              }
            }
            HStack {
                 if textInputParams.logoPlacement == .left {
                     Image(systemName: textInputParams.logoIcon).foregroundColor(.black).padding(.leading,textInputParams.textLeadingConstruent)
                   }
                
                if isSecure {
                    SecureField(textInputParams.placeholder, text: $textfield).autocapitalization(.none).onChange(of: textfield) { newValue in
                        textInputParams.inputText = newValue
                    }
                } else {
                   
                    TextField(textInputParams.placeholder, text: $textfield).autocapitalization(.none).onChange(of: textfield) { newValue in
                        textInputParams.inputText = newValue
                    }.onAppear {
                        textInputParams.inputText = textfield
                    }
                }
                
                if textInputParams.logoPlacement == .right {
                            Image(systemName: textInputParams.logoIcon).foregroundColor(.black)
                    }
            }.padding(textInputParams.padding)
//            .background(Color(UIColor.secondarySystemBackground))
            .background(Color(UIColor.white))
            .cornerRadius(8.0)
            Text(prompt)
                .foregroundColor(Color.gray)
            .fixedSize(horizontal: false, vertical: true)
            .font(.caption)
        }
    }
}

