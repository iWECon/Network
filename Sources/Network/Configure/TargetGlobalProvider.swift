//
//  Created by iWw on 2021/1/28.
//

import UIKit
import Alamofire
import Moya

/// TargetType 默认实现的一些参数
public protocol TargetGlobalProvider {
    
    /// All target's base `URL`.
    var baseURL: String { get }
    
    /// 全局参数: 单次请求超时时间，默认实现为 15 秒
    /// 如需覆盖, 可在对应的 Target 中使用 `var timeout: TimeInterval` 进行处理
    var timeout: TimeInterval { get }
    
    /// 单次请求的验证信息，默认不验证 `.none`
    var validationType: ValidationType { get }
    
    /// 全局参数: 静态 HTTP Headers, 实现后默认全局请求都会携带
    /// 若 Key 与 Target 携带的参数一致，则 Value 以 Target 携带的为准
    /// 如需关闭, 可在对应的 Target 中使用 `var behavior: Behavior`
    /// 参数值为 nil 时不会被请求携带
    var headers: [String: String?]? { get }
    
    /// 全局参数: 请求参数, 实现后默认全局请求都会携带
    /// 若 Key 与 Target 携带的参数一致，则 Value 以 Target 携带的为准
    /// 如需关闭, 可在对应的 Target 中使用 `var behavior: Behavior`
    /// 参数值为 nil 时不会被请求携带
    var parameters: [String: Any?]? { get }
    
    /// 全局参数: 插件, 实现后默认全局请求都会携带这些插件
    /// 如需关闭, 可在对应的 Target 中使用 `var behavior: Behavior`
    /// ⚠️ 除 `RequestTransformation` 外，其余所有插件均不响应 `func prepare(_:target:) -> URLRequest`
    /// 插件调用优先级:
    /// RequestTransformation > Logger > NetworkIndicator > 全局插件(这里的) > target 携带的插件.
    var plugins: [PluginType]? { get }
    
    /// Moya_doc: We also need a task computed property that returns the task type potentially including parameters.
    /// 如何发送/接受数据, 并且允许你向它添加数据、文件和流到请求体中, 详细说明请查阅 Moya 文档
    /// 默认实现仅提供 `.requestPlain` 和 `.requestParameters(parameters:encoding:)`
    func makeTask(with target: Target, params: [String: Any]) -> Task?
    
}

// MARK:- Default Implemention
public extension TargetGlobalProvider {
    
    var timeout: TimeInterval { 15 }
    
    var headers: [String: String?]? { nil }
    
    var parameters: [String: Any?]? { nil }
    
    var plugins: [PluginType]? { [] }
    
    var validationType: ValidationType { .none }
    
    func makeTask(with target: Target, params: [String : Any]) -> Task? { nil }
}


struct _DefaultTargetPropertiesProvider: TargetGlobalProvider {
    
    var baseURL: String {
        fatalError("baseURL has not been implemented")
    }
}
