//
//  FSReviewsRequest.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/13/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import Foundation
import AFNetworking
import Fuzi


typealias FSReviewsRequestClosureSuccess = (reviews: [FSReview]) -> Void

class FSReviewsRequest: FSWebRequest {
    
    var request: NSURLSessionDataTask?
    var success: FSReviewsRequestClosureSuccess?
    var movie: FSMovie?
    var offset = 0
    
    init(movie: FSMovie, offset: UInt, success: FSReviewsRequestClosureSuccess?, failure: FSClosureFailure?) {
        super.init(failure: failure)
        self.success = success
        self.movie = movie
        send()
    }
    
    override func send() {
        let urlString = FSWebRequest.fsHost + "/review/list/" + movie!.movieId!
        let parameters = ["loadedcount" : offset]
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
            
            let reviewNodes = document.xpath("//div").filter { (it) -> Bool in
                it.attr("itemtype") == "//data-vocabulary.org/Review"
            }
            for reviewNode in reviewNodes {
                let node = reviewNode.children.filter({ (it) -> Bool in
                    it.attr("class") == "b-item-material-comments__item-right"
                }).first
                let infoAndTextNodes = node?.xpath("div")
                guard nil != infoAndTextNodes && infoAndTextNodes?.count == 2 else {
                    continue
                }
                let infoNode = infoAndTextNodes![0]
                let textNode = infoAndTextNodes![1]
                
                let reviewIdString = reviewNode.attr("id")?.stringByReplacingOccurrencesOfString("comment_", withString: "")
                var review = existReviews.filter({ (it) -> Bool in
                    it.commentId == reviewIdString
                }).first
                
                if nil == review {
                    review = FSLocalStorage.sharedInstance.insertReview(inContext: context)
                    review!.commentId = reviewIdString
                }
                
                review!.positive = reviewNode.attr("class") == "b-item-material-comments__item b-item-material-comments__item-review-positive"
                review!.authorName = infoNode?.xpath("a/span").first?.stringValue
                review!.dateString = infoNode?.xpath("div/time").first?.stringValue
                review!.comment = textNode?.stringValue.stringByReplacingOccurrencesOfString("<br />", withString: "\n")
                review!.date = FSWebRequest.fsDateFormatter().dateFromString(review!.dateString!)
                
                let questionsNodes = infoNode?.xpath("div/a/span").filter({ (it) -> Bool in
                    it.attr("class") == "b-item-material-comments__item-answer-value"
                })
                if questionsNodes?.count == 2 {
                    let likesString = questionsNodes![0].stringValue
                    let dislikesString = questionsNodes![1].stringValue
                    review!.likes = Int32(likesString)!
                    review!.dislikes = Int32(dislikesString)!
                }
                
                evaluatedMovie.addReviewsValue(review!)
                reviews.append(review!)
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
