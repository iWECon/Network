//
//  Created by iWw on 2021/2/2.
//

import UIKit
import Alamofire

struct kEventMonitor: EventMonitor {
    
    static let shared = kEventMonitor()
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print("did receive data")
    }
    
    func requestDidFinish(_ request: Request) {
        print("request \(request), did finished.")
    }
    
    func requestIsRetrying(_ request: Request) {
        print("is retrying")
    }
}
