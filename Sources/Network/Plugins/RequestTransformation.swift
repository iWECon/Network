//
//  RequestTransformation.swift
//  Network
//
//  Created by iWw on 2021/1/28.
//

import UIKit
import Moya

struct RequestTransformation: PluginType {
    
    static var shared = RequestTransformation()
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let target = target as? Target else {
            return request
        }
        
        var request = request
        request.timeoutInterval = target.timeout ?? NetworkConfigure.shared.target.timeout
        
        guard let transformatedRequest = NetworkConfigure.shared.transformation?.transformation(request, target: target) else {
            return request
        }
        return transformatedRequest
    }
    
}
