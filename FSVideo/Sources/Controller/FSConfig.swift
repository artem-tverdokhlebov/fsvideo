//
//  FSConfig.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/21/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit


let kShouldPersonalizeScreensKey = "shouldPersonalizeScreens"
let kUseLightThemeKey = "kUseLightTheme"
let kUseFsToKey = "useFsTo"
let kUseExUaKey = "useExUa"


class FSConfig: NSObject {
    
    static let sharedInstance = FSConfig()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override init() {
        super.init()
        NSUserDefaults.standardUserDefaults().registerDefaults([
            kShouldPersonalizeScreensKey : true,
            kUseFsToKey: true,
            kUseExUaKey: true,
            kUseLightThemeKey: false,
        ])
    }
    
    var shouldPersonalizeScreens: Bool {
        get { return self[kShouldPersonalizeScreensKey] }
        set { self[kShouldPersonalizeScreensKey] = newValue }
    }
    
    var useLightTheme: Bool {
        get { return self[kUseLightThemeKey] }
        set { self[kUseLightThemeKey] = newValue }
    }
    
    var useFsTo: Bool {
        get { return self[kUseFsToKey] }
        set { self[kUseFsToKey] = newValue }
    }
    
    var useExUa: Bool {
        get { return self[kUseExUaKey] }
        set { self[kUseExUaKey] = newValue }
    }
    
    func useService(service: Int32) -> Bool {
        return service == FSMovie.SourceExUa ? self.useExUa : self.useFsTo
    }
    
    func canChangeService() -> Bool {
        return true
    }
    
    subscript (key: String) -> Bool {
        get {
            return defaults.boolForKey(key)
        }
        set {
            defaults.setBool(newValue, forKey: key)
            defaults.synchronize()
        }
    }
}
