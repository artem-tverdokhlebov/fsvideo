//
//  UIColorExtensions.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/16/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit


extension UIColor {
    
    func lightColor() -> UIColor {
        return newColorWithDifference(0.1)
    }
    
    func darkColor() -> UIColor {
        return newColorWithDifference(-0.1)
    }
    
    func newColorWithDifference(diff: CGFloat) -> UIColor {
        var red : CGFloat = 0.0
        var green : CGFloat = 0.0
        var blue : CGFloat = 0.0
        var alpha : CGFloat = 0.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        red += diff
        green += diff
        blue += diff
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
