//
//  Created by iWw on 2021/1/27.
//

import UIKit
import Moya
import Alamofire
import Lookup

public protocol TargetSharing where Self: Target {
    static var shared: Provider<Self> { get }
}

public protocol Target: TargetType {
    
    /// Single request's parameters.
    /// 单次请求携带的参数, value 为 nil 时会自动忽略
    var parameters: [String: Any?]? { get }
    
    /// Single request timeout.
    /// default value from `NetworkConfigure.shared.target.timeout`.
    /// 单次请求超时时间, 为 nil 时, 会从全局配置获取
    var timeout: TimeInterval? { get }
    
    /// Single request hot plugins.
    /// Default is empty array.
    /// 单次请求携带的插件.
    var plugins: [PluginType] { get }
    
    /// 单次请求行为, 具体查看 Behavior
    var behavior: Behavior { get }
    
    /// 单次请求日志行为, 默认为跟随整体 Logger 的开关
    var loggerControl: Logger.Control { get }
}

// MARK:- Default implemention for `Target`
public extension Target {
    
    var timeout: TimeInterval? { nil }
    
    var plugins: [PluginType] { [] }
    
    var behavior: Behavior { .default }
    
    var loggerControl: Logger.Control { .none }
}

// MARK:- Default implemention for `TargetType`
public extension Target {
    
    var baseURL: URL {
        URL(string: NetworkConfigure.shared.target.baseURL)!
    }
    
    var parameters: [String: Any?]? {
        nil
    }
    
    var headers: [String : String]? {
        nil
    }
    
    /// Reference `https://github.com/Moya/Moya/blob/master/docs/Targets.md`
    /// 参考 `https://github.com/Moya/Moya/blob/master/docs_CN/Targets.md`
    var task: Task {
        defaultTask
    }
    
    var validationType: ValidationType {
        NetworkConfigure.shared.target.validationType
    }
    
    var sampleData: Data {
        fatalError("sampleData has not been implemented")
    }
}

// MARK:- Only read for public
public extension Target {
    
    /// 根据条件(是否携带全局参数), 返回最终的参数
    var finalPararms: [String: Any] {
        var params: [String: Any] = parameters?.compactMapValues({ $0 }) ?? [:]
        if !behavior.contains(.ignoreGlobalParameters) {
            let globalParams = NetworkConfigure.shared.target.parameters?.compactMapValues({ $0 }) ?? [:]
            params.merge(globalParams, uniquingKeysWith: { (lhs, rhs) in lhs })
        }
        return params
    }
    
    /// 根据条件(是否携带全局Headers), 返回最终 Headers
    var finalHeaders: [String: String] {
        var headerFields: [String: String] = headers ?? [:]
        if !behavior.contains(.ignoreGlobalHeaders) {
            let globalHeaders = NetworkConfigure.shared.target.headers?.compactMapValues({ $0 }) ?? [:]
            headerFields.merge(globalHeaders, uniquingKeysWith: { (lhs, rhs) in lhs })
        }
        return headerFields
    }
    
    /// return `.requestPlain` or `.requestParameters`
    var defaultTask: Task {
        guard !finalPararms.isEmpty else {
            return .requestPlain
        }
        return .requestParameters(parameters: finalPararms, encoding: Alamofire.URLEncoding.default)
    }
}

// MARK:- Internal properties
extension Target {
    
    /// 根据条件(是否携带全局Plugins), 返回最终的 Plugins
    var finalHotPlugins: [PluginType] {
        var globalHotPlugins: [PluginType] = []
        if !behavior.contains(.ignoreGlobalPlugins) {
            globalHotPlugins = NetworkConfigure.shared.target.plugins ?? []
        }
        return globalHotPlugins + plugins
    }
    
    /// completed url
    var url: URL {
        self.path.isEmpty ? self.baseURL : self.baseURL.appendingPathComponent(self.path)
    }
    
}
