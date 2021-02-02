//
//  Created by iWw on 2021/1/28.
//

import UIKit
import Alamofire
import Moya

open class Provider<T: Target>: MoyaProvider<T> {
    
    public static var defaultPlugins: [PluginType] {
        [
            RequestTransformation.shared,
            Logger.shared,
            NetworkIndicatorHandler.shared,
            ResponseValidation.shared,
            HotPluginResponder.shared
        ]
    }
    
    override public init(endpointClosure: @escaping MoyaProvider<T>.EndpointClosure = Provider.endPointMapping,
                         requestClosure: @escaping MoyaProvider<T>.RequestClosure = MoyaProvider<T>.defaultRequestMapping,
                         stubClosure: @escaping MoyaProvider<T>.StubClosure = MoyaProvider.neverStub,
                         callbackQueue: DispatchQueue? = nil,
                         session: Session = MoyaProvider<T>.defaultAlamofireSession(),
                         plugins: [PluginType] = Provider<T>.defaultPlugins,
                         trackInflights: Bool = true) {
        
        super.init(endpointClosure: endpointClosure,
                   requestClosure: requestClosure,
                   stubClosure: stubClosure,
                   callbackQueue: callbackQueue,
                   session: session,
                   plugins: plugins,
                   trackInflights: trackInflights)
    }
    
    open class func endPointMapping(for target: T) -> Endpoint {
        return Endpoint(
            url: URL(target: target).absoluteString,
            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
            method: target.method,
            task: target.task,
            httpHeaderFields: target.finalHeaders
        )
    }
    
}
