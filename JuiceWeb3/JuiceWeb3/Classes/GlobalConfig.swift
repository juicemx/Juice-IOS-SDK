//
//  GlobalConfig.swift
//  JuiceWeb3
//
//  Created by jenkins on 2020/9/27.
//

import Foundation

public class GlobalConfig {
    
    public static let shared = JuiceConfig()
    
    public init() {}
    
    public var unitName: String = ""
    // Default: JUC
    public static var unit: String = "JUC"
}
