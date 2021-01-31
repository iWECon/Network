//
//  Target+RxSwift.swift
//  Network
//
//  Created by iWw on 2021/1/30.
//

import UIKit
import Moya
import RxMoya
import Lookup
import RxSwift
import Network

public extension Target where Self: TargetSharing {
    
    var request: Single<ResponseResult> {
        Self.shared.rx.request(self).map { (response) -> ResponseResult in
            ResponseResult(lookup: Lookup(try? response.mapJSON()), response: response)
        }
    }
    
}

public extension PrimitiveSequence where Trait == SingleTrait, Element == ResponseResult {
    
    var lookup: Single<Lookup?> {
        map { (v) in
            v.lookup
        }
    }
    
    var response: Single<Response> {
        map { (v) in
            v.response
        }
    }
    
    var rawData: Single<(Response, Lookup?)> {
        map { v in
            (v.response, v.lookup)
        }
    }
    
}
