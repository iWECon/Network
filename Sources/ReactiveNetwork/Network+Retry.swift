//
//  Created by iWw on 2021/2/1.
//

import UIKit
import Moya
import ReactiveMoya
import ReactiveSwift
import Lookup
import Network


// MARK:- Retry
public extension SignalProducer {
    
    func retry(when: @escaping (Error) -> Bool, times: UInt, interval: TimeInterval = 3, on scheduler: DateScheduler = QueueScheduler.main) -> SignalProducer<Value, Error> {
        if times == 0 {
            return producer
        }
        
        return flatMapError { (error) -> SignalProducer<Value, Error> in
            var retryProducer = SignalProducer<Value, Error>(error: error)
            if !when(error) {
                return retryProducer
            }
            if times > 0 {
                let delay = interval / TimeInterval(times)
                if times - 1 > 0 {
                    assert({ print("🌎 Retry after \(delay) seconds."); return true}())
                }
                retryProducer = SignalProducer.empty
                    .delay(delay, on: scheduler)
                    .concat(producer.retry(when: when, times: times - 1, interval: interval, on: scheduler))
            }
            return retryProducer
        }
    }
    
}
