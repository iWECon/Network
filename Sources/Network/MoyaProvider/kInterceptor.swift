//
//  Created by iWw on 2021/2/1.
//

import UIKit
import Alamofire
import Lookup
import Moya

class kInterceptor: RequestInterceptor {
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let _ = request.request,
              let afError = error.asAFError,
              afError.isResponseValidationError
        else {
            completion(.doNotRetry)
            return
        }
        
        if case .responseValidationFailed(let reason) = afError {
            if case .customValidationFailed(let validationFailedError) = reason,
               let moyaError = validationFailedError as? MoyaError {
                if case .underlying(let _error, _) = moyaError {
                    let nsError = _error as NSError
                    print("\n🌈 Retry count: \(request.retryCount), and error: \(nsError.localizedDescription)\n")
                }
            }
        }
        
        completion(.retryWithDelay(3))
    }
    
}


class kEventMonitor: EventMonitor {
    
//    func request(_ request: DataRequest, didValidateRequest urlRequest: URLRequest?, response: HTTPURLResponse, data: Data?, withResult result: Request.ValidationResult) {
//        print("received data: \(data ?? Data())")
//    }
//
//    /// Event called when a `DataRequest` creates a `DataResponse<Data?>` value without calling a `ResponseSerializer`.
//    func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
//        print("request did parse response: \(response.error?.localizedDescription ?? "EMPTY ERROR INFO")")
//    }
    
}
