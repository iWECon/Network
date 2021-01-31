//
//  Created by iWw on 2021/1/28.
//

import UIKit
import Moya

/// 热插件，独立于 Provider，单次请求可携带的插件
/// 所有热插件均不会响应 `prepare(_:target:)`
struct HotPluginResponder: PluginType {
    
    static var shared = HotPluginResponder()
    
    func hotPlugins(_ target: Target) -> [PluginType] {
        target.finalHotPlugins
    }
    
    func willSend(_ request: RequestType, target: TargetType) {
        guard let target = target as? Target else { return }
        hotPlugins(target).forEach({ $0.willSend(request, target: target) })
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        guard let target = target as? Target else { return }
        hotPlugins(target).forEach({ $0.didReceive(result, target: target) })
    }
    
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        guard let target = target as? Target else { return result }
        let proccessedResult = hotPlugins(target).reduce(result, {
            $1.process(result, target: target)
        })
        return proccessedResult
    }
    
}
