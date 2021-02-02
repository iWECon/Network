//
//  Created by iWw on 2021/1/27.
//

import UIKit
import Lookup
import Moya

public struct ResponseResult: CustomStringConvertible, CustomDebugStringConvertible {
    
    public let lookup: Lookup?
    public let response: Response!
    
    public init(lookup: Lookup?, response: Response) {
        self.lookup = lookup
        self.response = response
    }
    
    public var description: String {
        var logs = ""
        if let lp = lookup {
            logs += lp.description
        } else {
            logs += "Lookup is nil, "
        }
        logs += response.description
        return logs
    }
    
    public var debugDescription: String {
        description
    }
}
