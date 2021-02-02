//
//  Created by iWw on 2021/2/1.
//

import UIKit
import Alamofire

public struct NetworkReachability {
    
    public typealias Status = Alamofire.NetworkReachabilityManager.NetworkReachabilityStatus
    
    public static var shared = NetworkReachability()
    
    public func listen(onQueue queue: DispatchQueue = .main, listener: @escaping (Status) -> Void) {
        manager?.startListening(onQueue: queue, onUpdatePerforming: listener)
    }
    
    public var status: Status {
        manager?.status ?? .unknown
    }
    
    public var isReachable: Bool {
        manager?.isReachable ?? false
    }
    
    var manager: NetworkReachabilityManager? {
        NetworkReachabilityManager.default
    }
}
