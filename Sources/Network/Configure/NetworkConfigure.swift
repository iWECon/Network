import UIKit

public struct NetworkConfigure {
    private init() { }
    
    public static var shared = NetworkConfigure()
    
    /// target global provider
    public var target: TargetGlobalProvider = _DefaultTargetPropertiesProvider()
    
    /// request transformation provider
    public var transformation: RequestTransformationProvider?
    
    /// request response validation provider
    public var validation: ResponseValidationProvider?
    
    /// request logger
    public var logger: Logger = Logger.shared
    
}
