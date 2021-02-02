import UIKit

public struct NetworkConfigure {
    private init() { }
    
    public static var shared = NetworkConfigure()
    
    /// target global provider
    public var target: TargetGlobalProvider = _DefaultTargetPropertiesProvider()
    
    /// request transformation provider
    public var transformation: RequestTransformationProvider?
    
    public var retrier: RequestRetrierProvider?
    
    /// request response validation provider
    public var validation: ResponseValidationProvider?
    
    /// request logger
    public var logger: Logger = Logger.shared
    
    /// network reachability
    public lazy var networkReachability = NetworkReachability.shared
}
