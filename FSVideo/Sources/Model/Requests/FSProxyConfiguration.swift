//
//  FSProxyConfiguration.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 7/1/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit

class FSProxyConfiguration: NSObject {
    
    static var defaults = NSUserDefaults.standardUserDefaults()
    static let proxyHostKey = "proxy-host"
    static let proxyPortKey = "proxy-port"
    static let useProxyKey = "proxy-use"
    
    static let defaultHost = "176.123.220.60"
    static let defaultPort = 1080
    
    static var config: [String: AnyObject] {
        // 77.120.238.1:9999 brb.to
        // 176.123.220.60:1080 ex.ua
        // 92.242.108.65:1080 fs.to
        let proxyHost = self.host
        let proxyPort = self.port
        let proxyDict : [String: AnyObject] = [
            kCFStreamPropertySOCKSProxyHost as String: proxyHost,
            kCFStreamPropertySOCKSProxyPort as String: proxyPort,
            kCFStreamPropertySOCKSVersion as String: kCFStreamSocketSOCKSVersion4
        ]
        return proxyDict
    }

    static var host: String {
        get {
            let storred = NSUserDefaults.standardUserDefaults().objectForKey(proxyHostKey) as? String
            return nil != storred ? storred! : defaultHost
        }
        set {
            if newValue.length > 0 {
                NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: proxyHostKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }
    
    static var port: Int {
        get {
            let storred = NSUserDefaults.standardUserDefaults().objectForKey(proxyPortKey) as? Int
            return nil != storred ? storred! : defaultPort
        }
        set {
            if newValue >= 0 && newValue < 65536  {
                NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: proxyPortKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }
    
    static var isNeedProxy: Bool {
        get {
            var result = NSUserDefaults.standardUserDefaults().objectForKey(useProxyKey) as? Bool
            if nil == result {
                let currentLocale = NSLocale.currentLocale()
                let countryCode = currentLocale.objectForKey(NSLocaleCountryCode) as? String
                result = countryCode?.lowercaseString != "ua"
            }
            return result!
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: useProxyKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
