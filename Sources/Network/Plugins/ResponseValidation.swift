//
//  Created by iWw on 2021/1/28.
//

import UIKit
import Moya
import Lookup

struct ResponseValidation: PluginType {
    
    static var shared = ResponseValidation()
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        guard let target = target as? Target else { return }
        
        switch result {
        case .success(let response):
            let json = try? response.mapJSON() as? [AnyHashable: Any]
            NetworkConfigure.shared.validation?.validation(response, lookup: Lookup(json), target: target)
        case .failure(let error):
            NetworkConfigure.shared.validation?.validation(error.response, error: error, target: target)
        }
    }
    
}
