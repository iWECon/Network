//
//  File.swift
//  
//
//  Created by iWw on 2021/2/1.
//

import Moya
import Network

enum Github {
    case zen
}
extension Github: Target, TargetSharing {
    
    
    static var shared = Provider<Github>()
    
    var path: String {
        "/zens"
    }
    var method: Moya.Method {
        .get
    }
    
    var retryTimes: UInt {
        3
    }
}

struct TargetConfigure: TargetGlobalProvider {
    static let shared = TargetConfigure()
    
    var baseURL: String {
        "https://api.github.com"
    }
    
}
