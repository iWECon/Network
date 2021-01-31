//
//  Created by iWw on 2021/1/28.
//

import UIKit
import Moya

/// 业务层插件，处理状态栏网络请求图标的显示和隐藏
struct NetworkIndicatorHandler: PluginType {
    
    enum NetworkIndicatorChangeType {
        case began, ended
    }
    
    typealias NetworkIndicatorClosure = (_ change: NetworkIndicatorChangeType) -> Void
    
    static var requestsInflight: Int = 0
    
    static let shared = NetworkIndicatorHandler { action in
        switch action {
        case .began:
            requestsInflight += 1
        case .ended:
            requestsInflight -= 1
        }
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = requestsInflight > 0
        }
    }
    
    let networkActivityClosure: NetworkIndicatorClosure
    
    init(networkActivityClosure: @escaping NetworkIndicatorClosure) {
        self.networkActivityClosure = networkActivityClosure
    }
    
    public func willSend(_ request: RequestType, target: TargetType) {
        guard let target =  target as? Target else {
            networkActivityClosure(.began)
            return
        }
        guard target.behavior.contains(.hideActivityIndicator) else {
            networkActivityClosure(.began)
            return
        }
    }
    
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        guard let target =  target as? Target else {
            networkActivityClosure(.ended)
            return
        }
        guard target.behavior.contains(.hideActivityIndicator) else {
            networkActivityClosure(.ended)
            return
        }
    }
}
