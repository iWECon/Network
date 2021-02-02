//
//  File.swift
//  
//
//  Created by iWw on 2021/2/1.
//

import UIKit
import Moya
import Network

enum Github {
    case zen
    case userRepos
}
extension Github: Target, TargetSharing {
    
    static var shared = Provider<Github>()
    
    var path: String {
        switch self {
        case .zen:
            return "/zen"
        case .userRepos:
            return "/user/repos"
        }
    }
    var method: Moya.Method {
        .get
    }
    
    var validationType: ValidationType {
        .customCodes([200])
    }
}

struct TargetConfigure: TargetGlobalProvider {
    static let shared = TargetConfigure()
    
    var baseURL: String {
        "https://api.github.com"
    }
    
}
