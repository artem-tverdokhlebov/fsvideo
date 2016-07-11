//
//  FSLog.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 5/13/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit
import CocoaLumberjack

class FSLog: NSObject {

    class func configure() {
        DDLog.addLogger(DDTTYLogger.sharedInstance()) // TTY = Xcode console
        DDLog.addLogger(DDASLLogger.sharedInstance()) // ASL = Apple System Logs
        
        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = 60 * 60 * 24 * 7  // 7 days
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.addLogger(fileLogger)
    }
}
