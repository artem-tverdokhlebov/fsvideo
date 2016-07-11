//
//  UIImageExtensions.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/19/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit
import UIImageColors


extension UIImage {
    
    func getColors(width: CGFloat, completionHandler: (FSColorBundle) -> Void) {
        if FSConfig.sharedInstance.shouldPersonalizeScreens {
            let ratio = self.size.width / self.size.height
            let width: CGFloat = 100.0
            let size = CGSizeMake(width, width / ratio)
            getColors(size) { (imageColors: UIImageColors) in
                completionHandler(FSColorBundle(imageColors: imageColors))
            }
        } else {
            completionHandler(FSTheme.defaultColors())
        }
    }
}
