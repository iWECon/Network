//
//  Created by iWw on 2021/2/2.
//

import UIKit
import Alamofire

struct kEventMonitor: EventMonitor {
    
    func requestDidFinish(_ request: Request) {
        print("request did finished: \(request.description)")
    }
}
