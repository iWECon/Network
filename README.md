# Network

网络请求，基于 Moya 的二次封装，同时适配 ReactiveMoya 以及 RxMoya。


## Features

· 同时支持 ReactiveMoya 以及 RxMoya

· 更合理的插件配置，可随意增删插件，可全局配置插件，也可在 `target` 中独立添加插件

· 更方便的日志配置，可全局开关/可根据 `target` 的需求进行开关

· 更便捷的全局配置，可配置全局 `http headers`，`request parameters` 以及 `plugins`


## Global Configure

###### See: `NetworkConfigure.swift`

```swift
public struct NetworkConfigure {

    /// target global provider
    /// target 的全局配置，项目中使用提供一个全局配置即可
    public var target: TargetGlobalProvider = _DefaultTargetPropertiesProvider()

    /// request transformation provider
    /// 如有请求加密等需求，可实现该协议对其进行操作
    public var transformation: RequestTransformationProvider?

    /// request response validation provider
    /// 请求响应后的结果验证，如有统一的错误提示等操作，可在此处完成
    public var validation: ResponseValidationProvider?

    /// request logger
    /// 请求日志相关，具体可查看 Logger.swift
    public var logger: Logger = Logger.shared
}
```

###### About `TargetGlobalProvider`

```swift
public protocol TargetGlobalProvider {

    /// 网络请求的域名地址，该属性必须实现
    /// 实现后 Target 中如无覆盖配置，则会从此处获取 baseURL
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
    /// 框架默认插件 > 全局插件(这里的) > target 携带的插件.
    var plugins: [PluginType]? { get }
    
    /// Moya_doc: We also need a task computed property that returns the task type potentially including parameters.
    /// 如何发送/接受数据, 并且允许你向它添加数据、文件和流到请求体中, 详细说明请查阅 Moya 文档
    /// 默认实现仅提供 `.requestPlain` 和 `.requestParameters(parameters:encoding:)`
    func makeTask(with target: Target, params: [String: Any]) -> Task?
}
```

###### About `Target`

```swift

public protocol Target: TargetType {
    
    /// 单次请求携带的参数, value 为 nil 时会自动忽略
    var parameters: [String, Any?]? { get }
    
    /// Single request timeout.
    /// default value from `NetworkConfigure.shared.target.timeout`.
    /// 单次请求超时时间, 为 nil 时, 会从全局配置获取
    var timeout: TimeInterval? { get }
    
    /// Single request hot plugins.
    /// Default is empty.
    /// 单次请求携带的插件, 默认不携带任何插件.
    var plugins: [PluginType] { get }
    
    /// 单次请求行为, 具体查看 Behavior
    var behavior: Behavior { get }
    
    /// 单次请求日志行为, 默认为跟随整体 Logger 的开关
    var loggerControl: Logger.Control { get }
}
```


About `Behavior` 

```swift
public struct Behavior: OptionSet {

    /// is nothing to do, use default behavior.
    /// 什么都不做，使用默认的行为.
    public static let `default` =              Behavior([])

    /// 忽略全局 HTTP Headers, 默认行为不忽略
    public static let ignoreGlobalHeaders =    Behavior(rawValue: 1 << 0)
    
    /// 忽略全局参数, 默认行为不忽略
    public static let ignoreGlobalParameters = Behavior(rawValue: 1 << 1)
    
    /// 忽略全局插件, 默认行为不忽略
    public static let ignoreGlobalPlugins =    Behavior(rawValue: 1 << 2)
    
    /// 隐藏网络指示器, 默认行为不隐藏
    public static let hideActivityIndicator =  Behavior(rawValue: 1 << 3)
    
}
```


About `Logger.Control`

```swift
public extension Logger {
    enum Control {
        /// 跟随整体的 Logger 输出, 默认值
        case none

        /// 强制开启, 在 DEBUG 环境下, 即使关闭了 Logger 的整体输出, 单次的网络请求依然会输出日志
        case forceEnabled

        /// 强制关闭, 关闭后，即使开启了 Logger 的整体输出, 单次的网络请求依然不会输出日志
        case forceDisabled
    }
}
```

###### About `Logger` 

```swift
public struct Logger: PluginType {

    /// 日志输出配置
    /// 提供是否输出 paramter, headers 等选项
    public var configuration: Configuration = Configuration()
    
    /// 整体日志输出开关
    /// 关闭后，根据 Target 提供的 loggerControl 进行判断
    public var isEnabled: Bool = true
    
    /// 非 DEBUG 环境下自动关闭日志输出, 即使开启了整体日志输出也不会输出日志
    /// 默认开启
    public var isReleaseDisabled = true
    
}
```

###### About `ResponseResult`

ResponseResult 提供一个 `var lookup: Lookup?` 和原始的响应数据 `var response: Response` 
```swift
public struct ResponseResult {

    public let lookup: Lookup?
    public let response: Response!
    
}
```

about `Lookup`, see: `https://github.com/iWECon/Lookup`


## Quickly access

Just create a target global configuration and implement the `var baseURL: String`
```swift
import Network
struct TargetGlobal: TargetGlobalProvider {
    
    static let shared = TargetGlobal()
    
    var baseURL: String {
        return "your api service path"
    }
}
```

and set it to `NetworkConfigue.shared.target`
```swift
NetworkConfigure.shared.target = TargetGlobal.shared
```

that's easy.

and create api:
```swift
import Network
import Moya

enum API {
    case wallpapers
}

extension API: Target, TargetSharing {
    // from TargetSharing
    static var shared = Provider<API>()
    
    var path: String {
        "/wallpapers"
    }
    
    var method: Moya.Method {
        .get
    }
    
    var parameters: [String: Any?]? {
        nil
    }
}
```

and use it:
```swift
// rx
import Network
import RxNetwork

API.wallpapers.request.do(onSuccess: { (result) in 
    // do wanna you do
}).disposable(rx.disposBag)

// reactive
import Network
import ReactiveNetwork

API.wallpapers.request.on(value: { (result) in 
    // do wanna you do
})
```

that's all.


## installation

#### Swift Package

`.packge(url: "https://github.com/iWECon/Network", from: "1.0.0")`
