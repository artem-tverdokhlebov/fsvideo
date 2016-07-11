//
//  EXSearchRequest.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/30/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit
import AFNetworking
import Fuzi
import NSURL_QueryDictionary


class EXSearchRequest: FSWebRequest {

    var searchQuery: String!
    var request: NSURLSessionDataTask?
    var success: FSSearchRequestClosureSuccess?
    
    init(searchQuery: String!, success: FSSearchRequestClosureSuccess?, failure: FSClosureFailure?) {
        super.init(failure: failure)
        self.success = success
        self.searchQuery = searchQuery
        send()
    }
    
    override func send() {        
        let encodedQuery = searchQuery.stringByReplacingOccurrencesOfString(" ", withString: "+")
        let urlString = FSWebRequest.exHost + "/r_video_search"
        let parameters = ["s" : encodedQuery,
                          "per" : 100]
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
        self.request = self.manager.GET(urlString, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
    }
    
    func handleSuccess(xml: String) throws {
        let document = try XMLDocument(string: xml)
        
        FSLocalStorage.sharedInstance.createContext { (context) in
            let existMovies = FSLocalStorage.sharedInstance.movies(withPredicate: NSPredicate(format: "source = %d", FSMovie.SourceExUa), fromContext: context)
            
            var searchResults = [FSMovie]()
            let objectNodes = document.xpath("//object_list/object")
            for objectNode in objectNodes {
                let movieId = objectNode.attr("id")
                guard movieId != nil else {
                    continue
                }
                var movie = existMovies.filter({ (it: FSMovie) -> Bool in
                    it.movieId == movieId!
                }).first
                
                if nil == movie {
                    movie = FSLocalStorage.sharedInstance.insertMovie(inContext: context)
                    movie!.movieId = movieId!
                    movie!.link = "/" + movieId!
                    movie!.source = FSMovie.SourceExUa
                }
                
                movie?.title = objectNode.attr("title")
                movie?.movieDescription = objectNode.attr("header")
                
                if let thumbLink = objectNode.attr("thumb_url") {
                    var imgLink = NSURL(string: thumbLink)
                    imgLink = imgLink?.uq_URLByRemovingQuery()
                    movie?.poster = imgLink!.absoluteString
                }
                
                searchResults.append(movie!)
            }
            
            FSLocalStorage.sharedInstance.saveChanges(context)
            FSLocalStorage.sharedInstance.removeContext(context)
            if !self.isCancelled {
                dispatch_async(dispatch_get_main_queue(), {
                    let mainContext = FSLocalStorage.sharedInstance.mainObjectContext
                    let resultsInMainContext = searchResults.map({ (it: FSMovie) -> FSMovie in
                        return mainContext.objectWithID(it.objectID) as! FSMovie
                    })
                    self.success?(response: resultsInMainContext)
                })
            }
        }
    }
}
