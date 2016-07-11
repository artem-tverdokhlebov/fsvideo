//
//  EXReviewsRequest.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 5/2/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit
import AFNetworking
import Fuzi


class EXReviewsRequest: FSWebRequest {
    
    var request: NSURLSessionDataTask?
    var success: FSReviewsRequestClosureSuccess?
    var movie: FSMovie?
    var page = 0
    
    init(movie: FSMovie, page: UInt, success: FSReviewsRequestClosureSuccess?, failure: FSClosureFailure?) {
        super.init(failure: failure)
        self.success = success
        self.movie = movie
        send()
    }
    
    override func send() {
        let urlString = FSWebRequest.exHost + "/view_comments/" + movie!.movieId!
        let parameters = ["p" : page]
        let successBlock = { (task: NSURLSessionDataTask, responseObject: AnyObject?) -> Void in
            let htmlData = responseObject as? NSData
            guard htmlData != nil else {
                self.handleFailure(nil)
                return
            }
            let html = String(data: htmlData!, encoding: NSUTF8StringEncoding)
            guard html != nil else {
                self.handleFailure(nil)
                return
            }
            do {
                try self.handleSuccess(html!)
            } catch let error as NSError {
                self.handleFailure(error)
            }
        }
        
        let failureBlock = { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            self.handleFailure(error)
        }
        
        self.manager.responseSerializer = AFHTTPResponseSerializer()
        self.request = self.manager.GET(urlString, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
    }
    
    func handleSuccess(html: String) throws {
        let document = try HTMLDocument(string: html)
        FSLocalStorage.sharedInstance.createContext { (context) in
            let evaluatedMovie = context.objectWithID(self.movie!.objectID) as! FSMovie
            let existReviews = evaluatedMovie.reviews.allObjects as! [FSReview]
            var reviews = [FSReview]()
            
            let tableNode = document.xpath("//html/body/table/tr/td/table").filter({ (table) -> Bool in
                table.attr("class") == "comment"
            }).first
            if nil != tableNode {
                let reviewNodes = tableNode!.children(tag: "tr").map({ (tr) -> XMLElement in
                    tr.children(tag: "td").first!
                })
                
                for reviewNode in reviewNodes {
                    let titleNode = reviewNode.children(tag: "a").filter({ (a) -> Bool in
                        a.attr("href")?.rangeOfString("/view_comments/") != nil
                    }).first
                    
                    let usernameNode = reviewNode.children(tag: "a").filter({ (a) -> Bool in
                        a.attr("href")?.rangeOfString("/user/") != nil
                    }).first
                    
                    let dateNode = reviewNode.xpath("small/node()").first
                    
                    let contentNodes = reviewNode.children(tag: "p").filter({ (p) -> Bool in
                        p.children(tag: "span").count == 0
                    })
                    
                    guard titleNode != nil && usernameNode != nil && dateNode != nil && contentNodes.count > 0 else {
                        continue
                    }
                    
                    let reviewIdString = titleNode!.attr("href")?.replaced(["/view_comments/" : ""])
                    var review = existReviews.filter({ (it) -> Bool in
                        it.commentId == reviewIdString
                    }).first
                    
                    if nil == review {
                        review = FSLocalStorage.sharedInstance.insertReview(inContext: context)
                        review!.commentId = reviewIdString
                        evaluatedMovie.addReviewsValue(review!)
                    }
                    
                    review!.authorName = usernameNode?.attr("href")?.replaced(["/user/" : ""])
                    review!.dateString = dateNode?.stringValue
                    review!.date = FSWebRequest.exDateFormatter().dateFromString(review!.dateString!)
                    
                    let comment = ((contentNodes as [XMLElement]).map({ (it) -> String in
                        it.recursiveStringValue
                    }) as [String]).joinWithSeparator("\n\n").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    review!.comment = comment
                    
                    reviews.append(review!)
                }
            }
            
            FSLocalStorage.sharedInstance.saveChanges(context)
            FSLocalStorage.sharedInstance.removeContext(context)
            if !self.isCancelled {
                dispatch_async(dispatch_get_main_queue(), {
                    let mainContext = FSLocalStorage.sharedInstance.mainObjectContext
                    let reviewsInMainContext = reviews.map({ (it) -> FSReview in
                        return mainContext.objectWithID(it.objectID) as! FSReview
                    })
                    self.success?(reviews: reviewsInMainContext)
                })
            }
        }
    }
    
    override func cancel() {
        super.cancel()
        self.request?.cancel()
    }
}
