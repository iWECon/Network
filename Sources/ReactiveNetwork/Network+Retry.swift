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
                
                retryProducer = SignalProducer<Value, Error>.empty
                    .delay(delay, on: scheduler)
                    .concat(
                        producer.retry(when: when, times: times - 1, interval: interval, on: scheduler)
                            .on(starting: {
                                assert({ print("❌ Request retry after \(delay) seconds."); return true}())
                            })
                    )
            }
            return retryProducer
        }
    }
    
}
