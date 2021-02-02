//
//  File.swift
//  
//
//  Created by iWw on 2021/2/2.
//

import UIKit
import Moya

public extension MoyaError {
    
    var errorName: String {
        switch self {
        case .imageMapping: return "imageMapping"
        case .jsonMapping: return "jsonMapping"
        case .stringMapping: return "stringMapping"
        case .objectMapping: return "objectMapping"
        case .encodableMapping: return "encodableMapping"
        case .statusCode: return "statusCode"
        case .underlying: return "underlying"
        case .requestMapping: return "requestMapping"
        case .parameterEncoding: return "parameterEncoding"
        }
    }
    
}
