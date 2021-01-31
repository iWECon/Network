//
//  RequestTransformationProvider.swift
//  Network
//
//  Created by iWw on 2021/1/28.
//

import UIKit
import Moya

/// 发起请求前的 URLRequest 变化，可在此处对 URLRequest 进行修改、参数加密等操作
public protocol RequestTransformationProvider {
    
    func transformation(_ request: URLRequest, target: Target) -> URLRequest
    
}
