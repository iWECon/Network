//
//  Created by iWw on 2021/1/30.
//

import UIKit
import Moya
import ReactiveMoya
import ReactiveSwift
import Lookup
import Network
import Alamofire

public extension Target where Self: TargetSharing {
    
    var request: SignalProducer<ResponseResult, MoyaError> {
        Self.shared.reactive.request(self).map { (response) -> ResponseResult in
            ResponseResult(lookup: Lookup(try? response.mapJSON()), response: response)
        }
    }
    
    func request(retryWhen: @escaping (MoyaError) -> Bool,
                 times: UInt,
                 interval: TimeInterval = 3,
                 on scheduler: DateScheduler = QueueScheduler.main) -> SignalProducer<ResponseResult, MoyaError> {
        var producer = self.request
        if times > 0 {
            producer = producer.flatMapError { (moyaError) -> SignalProducer<ResponseResult, MoyaError> in
                SignalProducer<ResponseResult, MoyaError>(error: moyaError)
            }.retry(when: retryWhen, times: times - 1, interval: interval, on: scheduler)
        }
        return producer
    }
    
}

// MARK:- APIResponse Map
public extension SignalProducer where Value == ResponseResult {
    
    var lookup: SignalProducer<Lookup?, Error> {
        map { (v) in
            v.lookup
        }
    }
    
    var response: SignalProducer<Response, Error> {
        map { (v) in
            v.response
        }
    }
    
    var rawData: SignalProducer<(Response, Lookup?), Error> {
        map { (v) in
            (v.response, v.lookup)
        }
    }
}

// MARK:- CompactMap with `OptionalProtocol`, it's in ReactiveSwift
public extension SignalProducer where Value: OptionalProtocol {
    
    var unwrap: SignalProducer<Value.Wrapped, Error> {
        filterMap { (v) in
            v.optional
        }
    }
    
}

public extension SignalProducer {
    
    var ignoreErrors: SignalProducer<Value, Never> {
        flatMapError({ _ in SignalProducer<Value, Never>.empty })
    }
    
}
