//
//  ProfileView.swift
//  Nisumapp (iOS)
//
//  Created by sboju on 10/13/21.
//  Copyright © 2021 Nisum. All rights reserved.
//

import SwiftUI
import CoreLocation
import NisumNetwork
import UIKit
struct ProfileView: View {
    @State private var showImagePicker: Bool = false
    @State private var pickedImage : UIImage? = UIImage(data: (UserDefaults.standard.object(forKey: "currentImage") as? Data ?? UIImage(systemName: "person.circle")?.pngData())!)
    @State var loading = false
    @ObservedObject var model:ProfileModel
    @EnvironmentObject var appSetings:AppSettings
    @ObservedObject var nameInputText:TextInputParameters
    @ObservedObject var cityInputText:TextInputParameters
    let defaultsManager:DefaultsManager
    let logView:NetworkLogView
    @State var validateMsg1:String = ""
    
    @State private var shouldAnimate = false
    
    @State var managerDelegate = LocationManager()
    @State var manager = CLLocationManager()
    
    @StateObject var locationManager = LocationManager()
    var enableFormEditing = false
    var enablePicSelection = false
    @State var profileId:String = ""
    
    init() {
        profileId = UserDefaultsManager.shared.getStringValue(forKey: "ProfileId")
        
        defaultsManager = DefaultsManager()
        model = defaultsManager.getProfile()
        logView = NetworkCoreDataManager.shared.viewNetworkLogs(.all)
        nameInputText = TextInputParameters(labelName: "",placeholder: "Enter Name",logoIcon: "person.fill",minCharecters: 4,maxCharecters: 7,minValue: 0,maxValue: 0, securedEntry: false,validationType: .shouldNotContainNumbersAndSpecialCharecter,logoPlacement: .left,showLabel: true,padding: 0.0,textLeadingConstruent: 0.0)
        cityInputText = TextInputParameters(labelName: "", placeholder: "City",logoIcon: "building.2.fill",minCharecters: 3,maxCharecters: 0,minValue: 0,maxValue: 0, securedEntry: false,validationType: .shouldNotContainNumbersAndSpecialCharecter,logoPlacement: .left,showLabel: true,padding: 0,textLeadingConstruent: 0)
        if let image = model.profileImage{
            self.pickedImage  = image
        }
    }

    var body: some View {
        
        NavigationView{
            VStack(alignment:.leading, spacing: 20.0) {
                if profileId != "" {
                    NavigationInputView(model: model,nameInputText:nameInputText,cityInputText: cityInputText).frame(width: UIScreen.main.bounds.width - 40, height: 60).padding(.top,20)
                }
                
                if profileId == "" {
                        BasicCenterView()
                }
            HStack{
                Spacer()
                    ZStack{
                                        Image(uiImage: self.pickedImage!)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 120.0, height: 120.0)
                                            .cornerRadius(60)
                                            .shadow(radius: 10)
                
                                        Button{
                                            loading = true
                                            self.showImagePicker = true
                                            self.model.profileImage = self.pickedImage
                                            self.model.imageData = self.pickedImage?.pngData()
                                        } label: {
                                            Image(systemName: "camera.on.rectangle")
                                        }
                                        .padding(EdgeInsets(top: 80, leading: 80.0, bottom: 0.0, trailing: 0))
                                    }
                                    Spacer()
                                }.sheet(isPresented: self.$showImagePicker) {
                                    PhotoCaptureView(showImagePicker: self.$showImagePicker, pickedImage: self.$pickedImage)
                                        .onDisappear(){
                                            self.model.profileImage = self.pickedImage
                                        }
                                }

                Form() {
                    
                Section(header: Text("Nick Name")) {
                        TextInputView(prompt: nameInputText.ValidateString, textInputParams: nameInputText, textfield: $model.nickName).allowsHitTesting(model.isEnableFormEdit)
                    }
                    
                    Section(header: Text("CITY")) {
                       
                            //Image.city
                            TextInputView(prompt: cityInputText.ValidateString, textInputParams: cityInputText, textfield: $model.city).onAppear(perform: updateCity).allowsHitTesting(model.isEnableFormEdit)

                        
                    }


                    Section(header: Text(model.sectionLocation)) {
                        HStack{

                            Image.location
                            Picker("Country", selection: $model.countryDescirption){
                                ForEach(model.countriesArr.compactMap { $0.countryName }, id: \.self) { text in
                                              Text(text)
                                          }
                            }.disabled(!model.isEnableFormEdit)
                            .onChange(of: model.countryDescirption) { _ in
                                DispatchQueue.main.async {
                                    
                                    let filterdArr = model.countriesArr.filter {
                                        $0.countryName == model.countryDescirption
                                                    }
                                   
                                    guard let county1:Country = filterdArr.first  else {
                                        return
                                    }
                                    model.countryCode = county1.countryCode
                                    
                                    model.getProviencee(countriess: county1)
                                }
                            }

                        }.onAppear(){
                            if model.countriesArr.count == 0 {
                                if model.getCountriesCalled == false {
                                    model.getCountriess()
                                }
                            }
                        }
                        HStack{
                            Image.location
                            Picker("Provinces", selection: $model.provincesDescription) {
                                ForEach(model.provienceArr, id: \.self) {
                                    Text($0)
                                }
                            }.disabled(!model.isEnableFormEdit)
                                .onChange(of: model.provincesDescription) { prov in
                                    let filterdArr = model.statesArr1.filter {
                                        $0.name == model.provincesDescription
                                    }
                                    if let state1:Statess = filterdArr.first {
                                        model.provincesCode = state1.code ?? ""
                                    }
                                }
                                
                        }
                    }

                    Section(header: Text("NetworkLog")) {
                        NavigationLink(destination: logView) {
                            
                            Button("Show Logs") {
                            } .frame(minWidth: 100, maxWidth: 100, minHeight: 30)
                                .padding(.trailing, 10.0)
                        }.font(.body)
                            .accentColor(Color.red)
                    }
                   
                    
                if profileId == "" {
                    VStack(alignment: .leading, spacing: 5.0) {
                        Button {
                            model.toggleToaster()
                            self.saveProfile()
                        } label: {
                            Text("setup.name.save".localized)
                                .font(.body)
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding()
                                .accentColor(Color.systemPink)
                                .background(Color.white)
                                .cornerRadius(6.0)
                        }
                        .disabled(nameInputText.isValid == false || cityInputText.isValid == false || model.provincesDescription.count == 0)
                        .frame(minHeight: 20,maxHeight: 25)
                    }
                  }
                        
                }
            }
            .padding(10.0)
            .background(Color.secondarySystemBackground)
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
            .toast(isPresented: $model.isLoading) {
                ToastView("Loading...")
                        .toastViewStyle(IndefiniteProgressToastViewStyle())
            }
        }
    }

    

    
    func updateCity(){
        if self.model.city.count == 0 {
        if let placemark = managerDelegate.currentPlacemark {
            self.model.city = placemark.locality!
        }else if let placeMark = locationManager.currentPlacemark{
            self.model.city = placeMark.locality!
        }
      }
    }
    
    func saveProfile() {
        self.shouldAnimate = !self.shouldAnimate
        DataManager.shared.execute(asGroup: {
            DataManager.shared.setProfile(as: model)
            if UserDefaultsManager.shared.getStringValue(forKey: "Token").count > 0 {
                model.saveProfileInfo()
            }else{
                model.authenticateUser()
            }
            model.profileUpdated = {
                self.screenCompleted()
            }
        }) {
            self.shouldAnimate = false
        }
    }
    
    func screenCompleted() {
      
        DispatchQueue.main.async {
            self.shouldAnimate = false
            model.isLoading = false
            self.appSetings.screenState = .completedProfile
//            model.isEnableFormEdit = true
            DataManager.shared.setAppSettings(as: self.appSetings)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}



struct LoadingView : View {
    
    var body: some View {
        ZStack{
            Color(.systemBackground)
                .ignoresSafeArea()
                .opacity(0.3)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(4)
            
        }
    }
}



struct ActivityIndicator: UIViewRepresentable {
    @Binding var shouldAnimate: Bool
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView()
    }

    func updateUIView(_ uiView: UIActivityIndicatorView,
                      context: Context) {
        uiView.transform = CGAffineTransform(scaleX: 2, y: 2)
        if self.shouldAnimate {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}
