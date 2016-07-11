//
//  EXMovieInfoRequest.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 5/1/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit
import AFNetworking
import Fuzi


class EXMovieInfoRequest: FSWebRequest {

    var request: NSURLSessionDataTask?
    var success: FSClosureSuccess?
    var movie: FSMovie!

    init(movie: FSMovie, success: FSClosureSuccess?, failure: FSClosureFailure?) {
        super.init(failure: failure)
        self.success = success
        self.movie = movie
        send()
    }
    
    override func send() {        
        let urlString = FSWebRequest.exHost + "/r_video_view/" + movie.movieId!
        let successBlock = { (task: NSURLSessionDataTask, responseObject: AnyObject?) -> Void in
            let xmlData = responseObject as? NSData
            guard xmlData != nil else {
                self.handleFailure(nil)
                return
            }
            let xml = String(data: xmlData!, encoding: NSUTF8StringEncoding)
            guard xml != nil else {
                self.handleFailure(nil)
                return
            }
            do {
                try self.handleSuccess(xml!)
            } catch let error as NSError {
                self.handleFailure(error)
            }
        }
        
        let failureBlock = { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            self.handleFailure(error)
        }
        
        self.manager.requestSerializer.setValue("Video/15 CFNetwork/758.3.15 Darwin/15.4.0", forHTTPHeaderField: "User-Agent")
        self.manager.responseSerializer = AFHTTPResponseSerializer()
        self.request = self.manager.GET(urlString, parameters: nil, progress: nil, success: successBlock, failure: failureBlock)
    }
    
    func handleSuccess(xml: String) throws {
        let document = try XMLDocument(string: xml)
        
        FSLocalStorage.sharedInstance.createContext { (context) in
            let evaluatedMovie = context.objectWithID(self.movie!.objectID) as! FSMovie
            let existFiles = evaluatedMovie.files.allObjects as! [FSFile]
            
            let objectNode = document.xpath("//object").first
            guard nil != objectNode else {
                FSLocalStorage.sharedInstance.removeContext(context)
                self.failure?(error: NSError(domain: "dev.abodnya.fsvideo", code: -1, userInfo: nil))
                return
            }
            
            let descriptionNode = objectNode?.children(tag: "post").first
            evaluatedMovie.movieDescription = descriptionNode?.stringValue
            
            if let fileNodes = objectNode?.children(tag: "file_list").first?.children(tag: "file") {
                for (index, fileNode) in fileNodes.enumerate() {
                    let fileId = fileNode.attr("file_id")!
                    var file = existFiles.filter({ (it: FSFile) -> Bool in
                        return it.fileId == fileId
                    }).first
                    
                    if nil == file {
                        file = FSLocalStorage.sharedInstance.insertFile(inContext: context)
                        file?.fileId = fileId
                        file?.movie = evaluatedMovie
                    }
                    
                    let fileName = fileNode.attr("name")!
                    let fileExtension = fileNode.attr("ext")!
                    file?.sourceOrder = Int32(index)
                    file?.fileName = fileName + "." + fileExtension
                    file?.url = fileNode.attr("url")
                    file?.quality = fileExtension + " - " + fileNode.attr("width")! + "x" + fileNode.attr("height")!
                    file?.duration = Double(fileNode.attr("duration")!)!
                    file?.fileSize = Int64(fileNode.attr("size")!)!
                }
            }
            
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
