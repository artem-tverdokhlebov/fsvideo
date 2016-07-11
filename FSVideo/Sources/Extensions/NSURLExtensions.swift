//
//  NSURLExtensions.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/11/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import Foundation


extension NSURL {
    
    class func documents() -> NSURL {
        return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    }
    
    class func excludeFromBackupFileAtURL(fileURL: NSURL) {
        fileURL.excludeFromBackup()
    }
    
    func excludeFromBackup() {
        if NSFileManager.defaultManager().fileExistsAtPath(self.path!) {
            do {
                try self.setResourceValue(true, forKey: NSURLIsExcludedFromBackupKey)
            } catch let errorBackup as NSError {
                print("Error excluding %@ from backup %@", self.lastPathComponent!, errorBackup)
            }
        }
    }
}