//
//  Created by iWw on 2021/1/27.
//

import UIKit
import Lookup
import Moya

public struct ResponseResult {
    
    public let lookup: Lookup?
    public let response: Response!
    
    public init(lookup: Lookup?, response: Response) {
        self.lookup = lookup
        self.response = response
    }
}
