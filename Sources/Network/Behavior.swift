//
//  Created by iWw on 2021/1/31.
//

import UIKit

public struct Behavior: OptionSet {
    public let rawValue: Int64
    
    public init(rawValue: Int64) {
        self.rawValue = rawValue
    }
    
    /// is nothing to do, use default behavior.
    /// 什么都不做，使用默认的行为.
    public static let `default` =              Behavior([])
    
    /// 忽略全局 HTTP Headers, 默认行为不忽略
    public static let ignoreGlobalHeaders =    Behavior(rawValue: 1 << 0)
    
    /// 忽略全局参数, 默认行为不忽略
    public static let ignoreGlobalParameters = Behavior(rawValue: 1 << 1)
    
    /// 忽略全局插件, 默认行为不忽略
    public static let ignoreGlobalPlugins =    Behavior(rawValue: 1 << 2)
    
    /// 隐藏网络指示器, 默认行为不隐藏
    public static let hideActivityIndicator =  Behavior(rawValue: 1 << 3)
    
}
