//
//  Created by iWw on 2021/2/2.
//

import UIKit
import Moya

public enum ResponseError: Swift.Error {
    
    /// Moya Error
    case moyaError(MoyaError)
    
    /// api Error
    case error(code: Int, message: String?)
    
    
    public init(from: MoyaError) {
        switch from {
        case let .statusCode(response):
            
            self = .moyaError(MoyaError.statusCode(response))
            
        case let .underlying(_, response):
            // 网络层错误
            if let response = response {
                // 有响应，应该走到网关层错误去
                self = ResponseError(from: MoyaError.statusCode(response))
                return
            }
        default:
            break
        }
        self = .moyaError(from)
    }
    
    public init(code: Int, message: String?) {
        self = .error(code: code, message: message)
    }
}
