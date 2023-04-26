//
//  RequestHTTPTask.swift
//  
//
//  Created by nisum on 23/09/21.
//

import Foundation
import SwiftUI

/// enum type that defines the network task type
public enum HTTPTask {
    case request
    case requestParameters(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)
    
    case requestParametersAndHeaders(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?,
        additionHeaders: Bool)
    case requestMultiPartUpload(bodyParameters: Parameters?,
                            bodyEncoding: ParameterEncoding,
                            imageParameters: Parameters?,
                            additionHeaders: Bool)
}
