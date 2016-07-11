//
//  FSTheme.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/16/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit
import SwiftHEXColors

class FSTheme: NSObject {
    
    class func defaultColors() -> FSColorBundle! {
        return FSConfig.sharedInstance.useLightTheme ? light : dark
    }
    
    static let light = FSColorBundle(background: UIColor(hexString: "F9F9F9")!,
                                     primary: UIColor(hexString: "000000")!,
                                     secondary: UIColor(hexString: "856F67")!,
                                     details: UIColor(hexString: "323B42")!,
                                     statusBarStyle: .Default)
    
    
    static let dark = FSColorBundle(background: UIColor(hexString: "2B374C")!,
                                    primary: UIColor(hexString: "FFFFFF")!,
                                    secondary: UIColor(hexString: "979797")!,
                                    details: UIColor(hexString: "EBEBEB")!,
                                    statusBarStyle: .LightContent)
}
