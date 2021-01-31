//
//  Created by iWw on 2021/1/30.
//

import UIKit
import Moya
import Lookup

/// 收到请求结果后，对结果进行验证
public protocol ResponseValidationProvider {
    
    /// for success
    func validation(_ response: Response, lookup: Lookup?, target: Target)
    
    /// for failure
    func validation(_ response: Response?, error: MoyaError, target: Target)
    
}

public extension ResponseValidationProvider {
    
    func validation(_ response: Response, lookup: Lookup?, target: Target) { }
    
    func validation(_ response: Response?, error: MoyaError, target: Target) { }
    
}
