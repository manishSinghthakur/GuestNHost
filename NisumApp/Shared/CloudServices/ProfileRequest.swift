//
//  ProfileRequest.swift
//  Nisumapp (iOS)
//
//  Created by nisum on 23/12/21.
//  Copyright © 2021 Nisum. All rights reserved.
//

import Foundation
import NisumNetwork
import UIKit

class ProfileRequest<T: Decodable>: BaseServiceRequest<T> {
    
    typealias Response = T
    
    var profileModel: ProfileModel
    
    init(model: ProfileModel) {
        self.profileModel = model
        super.init()
    }
    
    override var path: String {
        let profileId = UserDefaultsManager.shared.getStringValue(forKey: "ProfileId")
        if profileId.count > 0 {
            return "/api/restaurant/profiles/\(profileId)"
        }else{
            return "/api/restaurant/profiles"
        }
    }
    
    override var httpMethod: HTTPMethod {
        let profileId = UserDefaultsManager.shared.getStringValue(forKey: "ProfileId")
        if profileId.count > 0 {
            return .put
        }else{
            return .post
        }
    }
    
    override var headers: NetworkHeaderInfo? {
        let boundary = self.generateBoundaryString()
        return NetworkHeaderInfo(with: environment, parameters: ["authorization": "network.authentication".localized + UserDefaultsManager.shared.getStringValue(forKey: "Token"), "Content-Type": "multipart/form-data; boundary=\(boundary)"])
    }
    
    override var task: HTTPTask {
        let parameters = ["nickName": profileModel.nickName,"city": profileModel.city,"country": profileModel.countryDescirption,"state": profileModel.provincesCode,"notificationToken": profileModel.deviceToken]
        var img = profileModel.profileImage
        var imagedetail :[String:Any]? = [:]
        if let imageData = UserDefaults.standard.object(forKey: "currentImage") as? Data {
            img = UIImage(data: imageData)
            UserDefaults.standard.removeObject(forKey: "currentImage")
            imagedetail = img != nil ? ["imageName": "profileImage","imageData": img!.pngData()!] : nil
        }
        return .requestMultiPartUpload(bodyParameters: ["profile": self.parameterToJson(parameters: parameters)], bodyEncoding: .multipartAndJsonEncoding, imageParameters: imagedetail, additionHeaders: true)
        
    }
    
    override func decode(_ data: Data) throws -> Response {
         let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any>
        let id  = json?["id"] as? String
        let nickName  = json?["nickName"] as? String
        let imageUrl = json?["imageUrl"]  as? String
        DispatchQueue.main.async {
            if imageUrl != nil {
                UserDefaultsManager.shared.setStringValue(forKey: "ProfileImageURL", value: imageUrl!)
                self.profileModel.imageUrl = imageUrl!
            }
            if id != nil {
                UserDefaultsManager.shared.setStringValue(forKey: "ProfileId", value: id!)
                self.profileModel.id = id!
            }
            self.profileModel.nickName = nickName!
            DataManager.shared.setProfile(as: self.profileModel)
        }
        guard let responseModel = try? JSONDecoder().decode(ProfileResponseModel.self, from: data) else {
            return ProfileResponseModel(id: "", nickName: "", city: "", state: "", country: "", imageURL: "") as! ProfileRequest<T>.Response
        }

        return responseModel as! ProfileRequest<T>.Response
    }
}
