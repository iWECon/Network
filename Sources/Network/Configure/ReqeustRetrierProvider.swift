//
//  Created by iWw on 2021/2/1.
//

import UIKit
import Alamofire
import Lookup

public protocol RequestRetrierProvider {
    
    /// 重试操作, 默认实现为不重试
    /// - Parameters:
    ///   - request: 请求信息, 可拿到 urlRequest 以及 response, 可根据具体的业务逻辑进行处理
    ///   - response: http url response
    ///   - lookup: lookup init with response
    ///   - error: 错误信息
    ///   - completion: 结果, 根据规则返回且必须调用, 否则网络请求不会继续执行
    func retry(with request: Request, response: HTTPURLResponse?, responseLookup lookup: Lookup?, dueTo error: Error, completion: @escaping (RetryResult) -> Void)
    
}

public extension RequestRetrierProvider {
    
    func retry(with request: Request, response: HTTPURLResponse?, responseLookup lookup: Lookup?, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        completion(.doNotRetry)
    }
    
}
