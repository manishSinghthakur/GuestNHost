//
//  NavigationInputView.swift
//  Nisum_Components
//
//  Created by Ratcha Mahesh Babu on 28/12/21.
//

import SwiftUI
struct NavigationInputView: View {
    
    @ObservedObject var model:ProfileModel = ProfileModel()
    @ObservedObject var nameInputText:TextInputParameters
    @ObservedObject var cityInputText:TextInputParameters
    @State var navigationTitle = "Settings"
    @EnvironmentObject var appSetings:AppSettings
    var isBackItemPresent:Bool = false
    var body: some View {
        ZStack {
            Color.systemGroupedBackground
                .edgesIgnoringSafeArea(.all)
            HStack {
                
                if model.isEnableFormEdit == true {
                    Button(action: {
                        model.isEnableFormEdit.toggle()
                    }) {
                        Text("Cancel").foregroundColor(.black)
                    }
                } else {
                    Button(action: {
                        refreshToken()
                    }) {
                        Label("", systemImage:"repeat.circle").foregroundColor(.green)
                    }
                }
                Spacer()
                Text(navigationTitle).navigationBarTitleDisplayMode(.inline)
                Spacer()
                
//                if model.isEnableFormEdit == false {
//                Button(action: {
//                    refreshToken()
//                }) {
//                    Label("", systemImage:"repeat.circle").foregroundColor(.green)
//                }
//                Spacer()
//             }
              
                Button(action: {
                    if model.isEnableFormEdit == true {
                        model.isLoading = true
                        saveProfile()
                    }
                    model.isEnableFormEdit.toggle()
                }) {
                    if model.isEnableFormEdit == true {
                        
                        Text("Save").foregroundColor(.black)
                        
                    } else {
                        Text("Edit").foregroundColor(.black)
                    }
                }.disabled(nameInputText.isValid == false || cityInputText.isValid == false)
            }.padding()
        }
    }
    
    func refreshToken(){
        
        DataManager.shared.execute(asGroup: {

            model.reAuthenticateUser()
        }){}

    }
    
    func saveProfile() {
        DataManager.shared.execute(asGroup: {
            DataManager.shared.setProfile(as: model)
            model.saveProfileInfo()
        }) {
        }
    }
    
    func screenCompleted() {
        DispatchQueue.main.async {
            self.appSetings.screenState = .completedProfile
            DataManager.shared.setAppSettings(as: self.appSetings)
        }
    }
}

//struct NavigationInputView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationInputView()
//    }
//}
