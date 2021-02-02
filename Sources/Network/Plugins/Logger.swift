//
//  Created by iWw on 2021/1/28.
//

import UIKit
import Moya

public struct Logger: PluginType {
    
    static var shared = Logger()
    
    /// 日志输出配置
    public var configuration: Configuration = Configuration()
    
    /// 整体日志输出开关
    /// 关闭后，根据 Target 提供的 loggerControl 进行判断
    public var isEnabled: Bool = true
    
    /// 非 DEBUG 环境下自动关闭日志输出, 即使开启了整体日志输出也不会输出日志
    /// 默认开启
    public var isReleaseDisabled = true
    
    public var isDebugEnv: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    func shouldOutputLog(with target: TargetType) -> Bool {
        guard let target = target as? Target else {
            return false
        }
        // release 模式下自动关闭日志输出
        if isReleaseDisabled && !isDebugEnv {
            return false
        }
        // debug 模式下根据条件处理是否需要输出
        return isEnabled || (isDebugEnv && target.loggerControl == .forceEnabled)
    }
    
    public func willSend(_ request: RequestType, target: TargetType) {
        guard shouldOutputLog(with: target) else { return }
        
        // output log
        configuration.output(willSend: request, with: target as! Target)
    }
    
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        guard shouldOutputLog(with: target) else { return }
        
        // output log
        configuration.output(didReceive: result, with: target as! Target)
    }
    
}

// MARK:- Configuration
public extension Logger {
    
    struct Configuration {
        
        public var startLine: String = "\n"
        public var endLine: String = "\n"
        
        public var prefixMark: String = "|"
        
        public var willSendOption: OutputOption = .willSend
        public var didReceiveOption: OutputOption = .didReceive
        
        func output(willSend request: RequestType, with target: Target) {
            DispatchQueue.global(qos: .utility).async {
                self.logNetwork(with: willSendOption, request: request, target: target)
            }
        }
        
        func output(didReceive result: Result<Response, MoyaError>, with target: Target) {
            DispatchQueue.global(qos: .utility).async {
                self.logNetwork(with: didReceiveOption, result: result, target: target)
            }
        }
    }
    
}

extension Logger.Configuration {
    
    func logNetwork(with options: OutputOption, request: RequestType, target: Target) {
        var logs = startLine
        logs += prefixMark + " 🌍 [Network.WillSend]\n"
        logs += format(with: options, willSend: true, request: request.request, target: target, sessionHeaders: request.sessionHeaders)
        logs += endLine
        print(logs)
    }
    
    func logNetwork(with options: OutputOption, result: Result<Response, MoyaError>, target: Target) {
        var logs = startLine
        logs += prefixMark + " 🌍 [Network.DidReceived]\n"
        switch result {
        case .success(let response):
            logs += format(with: options, request: response.request, target: target)
            logs += logNetworkResponse(response.response, data: response.data, target: target)
        case .failure(let moyaError):
            var response: HTTPURLResponse?
            switch moyaError {
            case .statusCode(let resp):
                response = resp.response
            case .underlying(_, let resp):
                response = resp?.response
            default:
                break
            }
            logs += format(with: options, request: nil, target: target)
            if response != nil {
                logs += logNetworkResponse(response, data: nil, target: target)
            }
            logs += "\n❌ [ERROR]: errorCode: \(moyaError.errorCode), info: \(moyaError.errorDescription ?? "[EMPTY]")"
        }
        logs += endLine
        print(logs)
    }
    
    func logNetworkResponse(_ response: HTTPURLResponse?, data: Data?, target: TargetType) -> String {
        guard let response = response else {
            return "\n🌈 Response: ⚠️ Received empty network response for \(target)"
        }
        
        var logs = ""
        if let data = data {
            func responseDataFormatter() -> Data {
                do {
                    let dataAsJSON = try JSONSerialization.jsonObject(with: data)
                    let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
                    return prettyData
                } catch {
                    return data
                }
            }
            logs += "\n🌈 Response: " + (String(data: responseDataFormatter(), encoding: .utf8) ?? "Empty")
        } else {
            func responseHeaders() -> String {
                let headers = response.headers.dictionary.prettyPrinted() ?? ""
                if headers.isEmpty {
                    return "[EMPTY]"
                }
                return headers
            }
            logs += "\n🌈 Response: ❌, Status Code: \(response.statusCode), Headers: \(responseHeaders())"
        }
        return logs
    }
    
    func format(with options: OutputOption, willSend: Bool = false, request: URLRequest?, target: Target, sessionHeaders: [String: String]? = nil) -> String {
        /**
         | 🌍 [NETWORK.WILLSEND]
         |    [URL]: xxxxxx
         | [METHOD]: GET/POST/PUT or other something
         |   [PATH]: path
         */
        var logs = ""
        if options.contains(.url) {
            logs += prefixMark + "\t [URL]: " + target.baseURL.absoluteString + target.path
        }
        if options.contains(.method) {
            logs += "\n" + prefixMark + " [METHOD]: " + target.method.rawValue
        }
        if options.contains(.path) {
            logs += "\n" + prefixMark + "\t[PATH]: \(target.path) \(willSend ? "WillSend" : "DidReceive")"
        }
        if let request = request, options.contains(.headers), let heads = request.allHTTPHeaderFields, !heads.isEmpty {
            var headers = heads
            if let sessionHeaders = sessionHeaders {
                headers.merge(sessionHeaders) { $1 }
            }
            logs += "\n" + "Request HTTP Header Fields: " + (headers.prettyPrinted() ?? "[EMPTY]")
        }
        if let request = request, options.contains(.params) {
            // body stream
            if let bodyStream = request.httpBodyStream {
                logs += "\n" + "Request http body stream: \(bodyStream.description)"
            }
            
            // url params
            let urlParams = (request.url?.params() ?? [:])
            logs += "\n" + "Request URL Parameters: \(urlParams.isEmpty ? "[Empty]" : urlParams.prettyPrinted() ?? "[Empty]")"
            
            // http body params
            if let bodyData = request.httpBody, let bodyParams = String(data: bodyData, encoding: .utf8) {
                logs += "\n" + "Request Body Parameters: \(bodyParams)"
            }
        }
        return logs
    }
}

// MARK:- OutputOption for Logger
public extension Logger.Configuration {
    
    struct OutputOption: OptionSet {
        public let rawValue: Int64
        
        public init(rawValue: Int64) {
            self.rawValue = rawValue
        }
        
        /// GET/POST/PUT/DELETE or other something
        public static let method = OutputOption(rawValue: 1 << 0)
        /// the completed url with path and `GET METHOD's Paramaters`
        public static let url = OutputOption(rawValue: 1 << 1)
        /// the path of url
        public static let path = OutputOption(rawValue: 1 << 5)
        /// the parameters
        public static let params = OutputOption(rawValue: 1 << 2)
        /// the headers
        public static let headers = OutputOption(rawValue: 1 << 3)
        
        
        public static let willSend: OutputOption = [.method, .path, .url, .params, .headers]
        public static let didReceive: OutputOption = [.method, .path, .url]
    }
    
}


// MARK:- Control for `Target`
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

// MARK:- Helper for print
extension Dictionary {
    func prettyPrinted() -> String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else {
            return nil
        }
        return String(data: jsonData, encoding: .utf8)
    }
}

extension URL {
    func params() -> [String: Any] {
        var dict = [String: Any]()
        if let components = URLComponents(url: self, resolvingAgainstBaseURL: false) {
            if let queryItems = components.queryItems {
                for item in queryItems {
                    dict[item.name] = item.value!
                }
            }
            return dict
        }
        return [:]
    }
}
