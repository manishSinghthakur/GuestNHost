//
//  File.swift
//  
//
//  Created by sboju on 10/12/21.
//

import Foundation

//  MARK: - Base Class
open class NetworkInfo{
    // MARK: - Properties
    public static let shared: NetworkInfo = NetworkInfo()
    public var version: String {
        let dictionary = Bundle(for: Self.self).infoDictionary!
        let version = String(describing: dictionary["CFBundleShortVersionString"] ?? "")
        let build = String(describing: dictionary["CFBundleVersion"] ?? "")
        return "Package \(version) (\(build))"
    }
}
