//
//  FSColorBundle.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/16/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit
import UIImageColors

class FSColorBundle: NSObject {
    
    var backgroundColor: UIColor!
    var primaryColor: UIColor!
    var secondaryColor: UIColor!
    var detailColor: UIColor!
    var statusBarStyle: UIStatusBarStyle!
    
    init(imageColors: UIImageColors!) {
        super.init()
        self.statusBarStyle = imageColors.backgroundColor.isDarkColor ? UIStatusBarStyle.LightContent : UIStatusBarStyle.Default
        self.backgroundColor = imageColors.backgroundColor
        self.primaryColor = imageColors.primaryColor
        self.secondaryColor = imageColors.secondaryColor
        self.detailColor = imageColors.detailColor
    }
    
    init(background: UIColor!, primary: UIColor!, secondary: UIColor!, details: UIColor!, statusBarStyle: UIStatusBarStyle!) {
        self.statusBarStyle = statusBarStyle
        self.backgroundColor = background
        self.primaryColor = primary
        self.secondaryColor = secondary
        self.detailColor = details
    }
}

extension FSColorBundle: NSCopying {
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let colors = FSColorBundle(background: self.backgroundColor, primary: self.primaryColor, secondary: self.secondaryColor, details: self.detailColor, statusBarStyle: self.statusBarStyle)
        return colors
    }
}
