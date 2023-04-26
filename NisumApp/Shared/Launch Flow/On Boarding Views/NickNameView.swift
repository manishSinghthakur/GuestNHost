//
//  NickNameView.swift
//  Nisumapp (iOS)
//
//  Created by sboju on 10/13/21.
//  Copyright © 2021 Nisum. All rights reserved.
//

import SwiftUI
import NisumNetwork
struct NickNameView: View {
    @ObservedObject var model:ProfileModel
    @EnvironmentObject var appSetings:AppSettings
    @ObservedObject var textInput:TextInputParameters
 
    init() {
        model = ProfileModel()
        textInput = TextInputParameters(labelName: "Nick Name", placeholder: "Joe", logoIcon: "person.fill", minCharecters: 4, maxCharecters: 7, minValue: 0, maxValue: 0,securedEntry:false, validationType: .shouldNotContainNumbersAndSpecialCharecter, logoPlacement: .left,showLabel: true,padding: 10,textLeadingConstruent: 10,textTrallingConstruent: 0)
    }

    
    var body: some View {
      VStack {
            
            VStack{
                TextInputView(prompt: textInput.ValidateString, textInputParams: textInput, textfield: $model.nickName)
            }.padding(.top,60)
            BasicCenterView()
            Button {
                self.saveNickName()
            } label: {
                Text("setup.name.save".localized)
                    .font(.body)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .accentColor(Color.systemPink)
                    .background(Color.white)
                    .cornerRadius(6.0)
            }
            .disabled(textInput.isValid == false)
            Spacer()
            .frame(height:20.0)
        }
        .padding(20.0)
        .background(Color.secondarySystemBackground)
        .edgesIgnoringSafeArea(.all)
    }
    
    func saveNickName() {
        DataManager.shared.execute(asGroup: {
            let authRequest = AuthenticationRequest<AuthenticationResponseModel>()
            NetworkManager.shared.request(authRequest, screenName: "Token Authentication", action: "Login") {_ in }
            
            DataManager.shared.setProfile(as: model)
        }) {
            self.screenCompleted()
        }
    }
    
    func screenCompleted() {
        DispatchQueue.main.async {
            self.appSetings.screenState = .completedNickName
            DataManager.shared.setAppSettings(as: self.appSetings)
        }
    }
}

struct NickNameView_Previews: PreviewProvider {
    static var previews: some View {
        NickNameView()
    }
}

