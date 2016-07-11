//
//  EXFileURLRequest.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 5/6/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit
import AFNetworking


class EXFileURLRequest: FSWebRequest {
    
    var request: NSURLSessionDataTask?
    var success: FSClosureSuccess?
    var file: FSFile?
    
    init(file: FSFile!, success: FSClosureSuccess?, failure: FSClosureFailure?) {
        super.init(failure: failure)
        self.success = success
        self.file = file
        send()
    }
    
    override func send() {
        var sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        #if EXTENDED
            if FSProxyConfiguration.isNeedProxy {
                sessionConfiguration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
                sessionConfiguration.connectionProxyDictionary = FSProxyConfiguration.config
            }
        #endif
        
        let request = NSMutableURLRequest(URL: file!.onlineURL!)
        request.setValue("AppleCoreMedia/1.0.0.13E238 (iPhone; U; CPU OS 9_3_1 like Mac OS X; en_us)", forHTTPHeaderField: "User-Agent")
        
        let session = NSURLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        self.request = session.dataTaskWithRequest(request)
        self.request?.resume()
    }
    
    func handleSuccess(url: String) {
        FSLocalStorage.sharedInstance.createContext { (context) in
            let evaluatedFile = context.objectWithID(self.file!.objectID) as! FSFile
            
            evaluatedFile.url = url
            
            FSLocalStorage.sharedInstance.saveChanges(context)
            FSLocalStorage.sharedInstance.removeContext(context)
            if !self.isCancelled {
                dispatch_async(dispatch_get_main_queue(), {
                    self.success?()
                })
            }
        }
    }
    
    override func cancel() {
        super.cancel()
        self.request?.cancel()
    }
}

extension EXFileURLRequest: NSURLSessionDataDelegate {
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        if let url = dataTask.response?.URL?.absoluteString {
            self.handleSuccess(url)
        } else {
            self.handleFailure(nil)
        }
        dataTask.cancel()
    }
    
    func URLSession(session: NSURLSession, didBecomeInvalidWithError error: NSError?) {
        self.handleFailure(error)
    }
}
