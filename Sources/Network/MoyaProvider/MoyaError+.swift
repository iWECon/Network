//
//  File.swift
//  
//
//  Created by iWw on 2021/2/2.
//

import UIKit
import Moya

public extension MoyaError {
    
    static var shouldRetry: MoyaError {
        MoyaError.underlying(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "response validation should retry"]), nil)
    }
    
}
