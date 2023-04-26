//
//  ProfileModel.swift
//  Nisumapp (iOS)
//
//  Created by sboju on 10/15/21.
//  Copyright © 2021 Nisum. All rights reserved.
//

import Combine
import Foundation
import CoreLocation
import NisumNetwork
import SwiftUI

enum Validation {
    case success
    case failure(message: String)
    
    var isSuccess: Bool {
        if case .success = self {
            return true
        }
        return false
    }
}

enum toastTypee:String {
    case successType = "success"
    case failureType = "falure"
    case warningType = "warning"
    case infoType = "info"
}

class ProfileModel: ObservableObject {
    let sectionName:String = "setup.name.label".localized
    let sectionLocation:String = "setup.location.label".localized
    let placeholderCity:String = "setup.city.placeholder".localized
    let placeholderName:String = "setup.name.placeholder".localized
    @Published var nickName: String = ""
    @Published var nickNameMessage: String = ""
    @Published var nickNameValid:Bool = false
    @Published var city: String = ""
    @Published var state: String = ""
    @Published var cityMessage: String = ""
    @Published var cityValid:Bool = false
    @Published var countryCode: String = "US"
    @Published var countryDescirption: String = ""
    @Published var provincesDescription: String = ""
    @Published var provincesCode:String = ""
    @Published var deviceToken: String = ""
    @Published var isProfileValid:Bool = false
    @Published var isEnableFormEdit = false
    @Published var profileImage:UIImage? = UIImage(systemName: "person.circle")
    @Published var imageData:Data?
    @Published var imageUrl: String = ""
    @Published var id: String = ""
    @Published var isToasterPreset:Bool = false
    @Published var isLoading:Bool = false
    @Published var toasterType = "success"
    @Published var countriesObjectArr:[Any] = []
    @Published var getCountriesCalled:Bool = false
   // @Published var countriesArr:[String] = []
    @Published var provienceArr:[String] = []
    @Published var validationMsg:String = ""
    @Published var TosterMessage:String = ""
    var resturentCountriesModel:ResturantCountriesResponceModel?
    var countriesArr:[Country] = []
    var statesArr1:[Statess] = []
    
    
    var countryModel:Country?
    var stateModel:Statess?

    var profileUpdated : (() -> ()) = {}
    
    var locationManager = LocationManager()
    
    private var cancelables = Set<AnyCancellable>()
    private var isValidNickName: AnyPublisher<Bool, Never> {
        $nickName
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .map{ $0.count >= 3 }
            .eraseToAnyPublisher()
    }
    
    private var isValidCity:AnyPublisher<Bool, Never> {
        $city
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { $0.count > 0 }
            .eraseToAnyPublisher()
    }
    
    private var isValidCountry:AnyPublisher<Bool, Never> {
        $countryCode
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { $0.count > 0 }
            .eraseToAnyPublisher()
    }
    
    private var isAllValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isValidNickName, isValidCountry)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }
    
    
    init() {
        
         let profileId = UserDefaultsManager.shared.getStringValue(forKey: "ProfileId")
            if profileId.count > 0 {
                isEnableFormEdit = false
            } else {
                isEnableFormEdit = true
            }
        
        
        isAllValid
            .receive(on: RunLoop.main)
            .assign(to: \.isProfileValid, on: self)
            .store(in: &cancelables)
        
        isValidNickName
            .dropFirst()
            .receive(on: RunLoop.main)
            .map { isValid in
                self.nickNameValid = isValid
                if isValid { return "" }
                else { return "setup.name.failedName".localized }
            }
            .assign(to: \.nickNameMessage, on: self)
            .store(in: &cancelables)
        
        isValidCity
            .dropFirst()
            .receive(on: RunLoop.main)
            .map { isValid in
                self.cityValid = isValid
                if isValid { return "" }
                else { return "setup.city.failedCity".localized }
            }
            .assign(to: \.cityMessage, on: self)
            .store(in: &cancelables)
        self.fetchSavedResturantsCountries()
        
        updateCountryDescription()

        if let imageData = UserDefaults.standard.object(forKey: "currentImage") as? Data{
            profileImage = UIImage(data: imageData)
        }else{
            let url = UserDefaultsManager.shared.getStringValue(forKey: "ProfileImageURL")
            if url.count > 0 {
                if let data = try? Data(contentsOf: URL(string: url)!) {
                    DispatchQueue.main.async {
                        self.profileImage = UIImage(data: data)!
                    }
                }
            }
        }
    }
    
    
    
    func getCountriess(){
        if checkWeatherJWTTokenExist() == true {
            getCountriesFromServer()
        } else {
            autenticateTokenAndGetCountriesFromServer()
        }
    }
    
    
    
    func getCountriesFromServer(){
        getCountriesCalled = true
        let locationCountries = RestaurantLocationSelectionRequest<ResturantCountriesResponceModel>("countries")
        NetworkManager.shared.request(locationCountries, screenName: "Location", action: "LocationAction"){ result in
            switch result {
            case .success(let response):
                self.resturentCountriesModel = response
                DispatchQueue.main.async {
                    self.countriesArr = self.resturentCountriesModel?.country ?? []
                    if self.countryDescirption.count > 0 {
                        let filterdArr = self.countriesArr.filter {
                            $0.countryName == self.countryDescirption
                                        }
                        guard let county1:Country = filterdArr.first  else {
                            return
                        }
                        self.getProviencee(countriess: county1)
                        self.saveCountries()
                    }
                }

            case .failure(let error):
                print(error.errorDescription ?? "")
              //  self.getSavedCountries()
               
            }
        }
    }
    
    
    func autenticateTokenAndGetCountriesFromServer(){
        let authRequest = AuthenticationRequest<AuthenticationResponseModel>()
        NetworkManager.shared.request(authRequest, screenName: "Token Authentication", action: "Login") { result in
            switch result {
            case .success(_):
                self.getCountriesFromServer()


            case .failure(let error):
                print(error.errorDescription ?? "")
            }
        }
    }
    
    
    func checkWeatherJWTTokenExist() -> Bool{
         let token = UserDefaultsManager.shared.getStringValue(forKey: "Token")
            if token.count > 0 {
                return true
            } else {
                return false
            }
    }
    
    func saveCountries(){
        let encoder = JSONEncoder()
                   if let encoded = try? encoder.encode(resturentCountriesModel) {
                       UserDefaults.standard.set(encoded, forKey: "saved_resturentCountries")
                   }
    }
    
    func fetchSavedResturantsCountries(){
        if let data = UserDefaults.standard.object(forKey: "saved_resturentCountries") as? Data {
            let decoder = JSONDecoder()
            if let savedData = try? decoder.decode(ResturantCountriesResponceModel.self, from: data) {
                print(savedData)
                self.resturentCountriesModel = savedData
                DispatchQueue.main.async {
                    self.countriesArr = self.resturentCountriesModel?.country ?? []
                    if self.countryDescirption.count > 0 {
                        let filterdArr = self.countriesArr.filter {
                            $0.countryName == self.countryDescirption
                                        }
                        guard let county1:Country = filterdArr.first  else {
                            return
                        }
                        self.getProviencee(countriess: county1)
                    }
                }
            }
        }
    }
    
    
    func getProviencee(countriess:Country) {
        
        statesArr1 = countriess.statess
        let states = countriess.statess
        provienceArr = states.compactMap { $0.name }
    }
    
    
    // Get country name using Country code
    func getCountryNameByCountryCode(countryCode1:String) -> String {
        let filterdArr = countriesArr.filter {
            $0.countryCode == countryCode1
                        }
      
        if filterdArr.count > 0 {
            let county1:Country = filterdArr.first!
            return county1.countryName
        }
        return ""
    }
    
    // Get State name using State code
    func getStateNameByStateCode(stateCodee:String) -> String {
        let filterdArr = statesArr1.filter {
            $0.code == stateCodee
                }
        if filterdArr.count > 0 {
        let provicene:Statess = filterdArr.first!
            return provicene.name
        }
        return ""
    }
    
    
// This is used to load any json file for temperary parsing of data
func loadData(fileName:String) -> Data {
    if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
        if let nsdata = NSData(contentsOf: url) {
            let data = Data(referencing: nsdata)
            return data
        }
        print("Error unable to load json file")
    }
    return Data()
}

    func updateCountryDescription() {
        guard
            let code = NSLocale.current.regionCode,
            let description = NSLocale.current.localizedString(forRegionCode: code)
        else {
            self.countryDescirption = self.countryDescirption
            return
        }
        self.countryCode = code
        self.countryDescirption = description
        
        
        
        locationManager.locationUpdated = {
            DispatchQueue.main.async { [self] in
                if city.count == 0 {
                    self.city = locationManager.currentPlacemark.locality!
                }
                if countryDescirption.count == 0 {
                    self.countryDescirption = locationManager.currentPlacemark.country!
                }
                if locationManager.currentPlacemark.administrativeArea != nil {
                    self.provincesCode = locationManager.currentPlacemark.administrativeArea!
                    let stateName = getStateNameByStateCode(stateCodee: self.provincesCode)
                    if stateName.count > 0 {
                        self.provincesDescription = stateName
                    }
                }
            }
        }
    }
    
    func authenticateUser() {
        let authRequest = AuthenticationRequest<AuthenticationResponseModel>()
        NetworkManager.shared.request(authRequest, screenName: "Token Authentication", action: "Login") { result in
            switch result {
            case .success(_):
                self.saveProfileInfo()
            case .failure(let error):
                print(error.errorDescription ?? "")
                self.TosterMessage = "Failure"
                self.toggleToaster()
            }
        }
    }
    
    func reAuthenticateUser() {
        UserDefaultsManager.shared.setStringValue(forKey: "Token", value: "")
        let authRequest = AuthenticationRequest<AuthenticationResponseModel>()
        NetworkManager.shared.request(authRequest, screenName: "Token Authentication", action: "Login") { result in
            switch result {
            case .success(_): break
            case .failure(let error):
                print(error.errorDescription ?? "")
            }
        }
    }
    
    func saveProfileInfo(){
        let profileRequest = ProfileRequest<ProfileResponseModel>(model: self)
        NetworkManager.shared.request(profileRequest, screenName: "Profile", action: "Launch") { [self] result in
            switch result {
            case .success(_):
                self.updateToasterMessage(toasterMessage: "Success")
                self.toggleToaster()
                profileUpdated()

            case .failure(let error):
                self.updateToasterMessage(toasterMessage: "Failure")
                self.toggleToaster()
                print(error.errorDescription ?? "")
                
            }
        }
    }
    
    func toggleToaster(){
        DispatchQueue.main.async {
            self.isLoading.toggle()
           // self.isToasterPreset.toggle()
        }
    }

    
    func updateToasterMessage(toasterMessage:String){
        DispatchQueue.main.async {
            self.TosterMessage = toasterMessage
        }
    }
    
}
