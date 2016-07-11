//
//  FSPurchasesController.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 7/3/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit

class FSPurchasesController: NSObject {
    
    static let sharedInstance = FSPurchasesController()
    
    let maxDownloadsInLimitVersion = 5
    let purchasePrice = 1.99
    
    let purchaseInfoKey = "purchaseInfo"
    
    // PayPal
    let sandboxAccount = "fermerasb-facilitator@gmail.com"
    let accessToken = "access_token$sandbox$ns5skvpvdk5n3w7j$f318f331095f5d796d1c75625696bf72"
    
    var isPurchased: Bool {
        get {
            #if !DEBUG
                return true
            #else
                let key = NSUserDefaults.standardUserDefaults().objectForKey(purchaseInfoKey) as? String
                let udid = UIDevice.currentDevice().identifierForVendor?.UUIDString
                let decrypted = String(udid)
                return key == decrypted
            #endif
        }
    }
    
    var purchaseInfo: String? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey(purchaseInfoKey) as? String
        }
        set {
            if newValue?.length > 0 {
                NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: purchaseInfoKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }
    
    
}
