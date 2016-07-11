//
//  FSWebRequest.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/11/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit
import AFNetworking

typealias FSClosureSuccess = () -> Void
typealias FSClosureFailure = (error: NSError) -> Void


class FSWebRequest: NSObject {
    
    static let fsHost = "http://fs.to"
    static let exHost = "http://ex.ua"
    
    var isCancelled = false
    var failure: FSClosureFailure?
    var manager: AFHTTPSessionManager!
    var retryCount = 0
    let maxRetryCount = 5
    
    private static var _fsDateFormatter: NSDateFormatter?
    class func fsDateFormatter() -> NSDateFormatter! {
        if nil == _fsDateFormatter {
            _fsDateFormatter = NSDateFormatter()
            _fsDateFormatter!.locale = NSLocale(localeIdentifier: "ru_RU")
            _fsDateFormatter!.dateFormat = ("dd MMMM yyyy в HH:mm")
            _fsDateFormatter!.timeZone = NSTimeZone(name: "Europe/Kiev")
        }
        return _fsDateFormatter!
    }
    
    private static var _exDateFormatter: NSDateFormatter?
    class func exDateFormatter() -> NSDateFormatter! {
        if nil == _exDateFormatter {
            _exDateFormatter = NSDateFormatter()
            _exDateFormatter!.locale = NSLocale.currentLocale()
            _exDateFormatter!.dateFormat = ("HH:mm, dd MMMM yyyy")
            _exDateFormatter!.timeZone = NSTimeZone(name: "Europe/Kiev")
        }
        return _exDateFormatter!
    }
    
    init(failure: FSClosureFailure?) {
        super.init()
        self.failure = failure
        
        var sessionConfiguration: NSURLSessionConfiguration? = nil
        #if EXTENDED
        if FSProxyConfiguration.isNeedProxy {
            sessionConfiguration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
            sessionConfiguration?.connectionProxyDictionary = FSProxyConfiguration.config
        }
        #endif
        
        self.manager = AFHTTPSessionManager(sessionConfiguration: sessionConfiguration)
    }
    
    func send() {
        
    }
    
    func handleFailure(inError: NSError?) {
        var error = inError
        if error == nil {
            error = NSError(domain: "dev.abodnya.fsvideo", code: -1, userInfo: nil)
        }
        print("Failed request " + self.description + " with error: " + error!.description)
        if error!.domain == NSPOSIXErrorDomain && error!.code == 54 && self.retryCount < self.maxRetryCount {
            self.retryCount += 1
            print("Retry")
            self.send()
        } else {
            self.failure?(error: error!)
        }
    }
    
    func cancel() {
        isCancelled = true
    }
}
