//
//  FSSearchRequest.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/11/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit
import AFNetworking


typealias FSSearchRequestClosureSuccess = (response: [FSMovie]) -> Void

class FSSearchRequest: FSWebRequest {
    
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
        let encodedQuery = searchQuery.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) as String!
        let urlString = FSWebRequest.fsHost + "/search.aspx"
        let parameters = ["f" : "quick_search",
                          "section" : "video",
                          "search" : encodedQuery]
        let successBlock = { (task: NSURLSessionDataTask, responseObject: AnyObject?) -> Void in
            if let dictionary = responseObject as? [[String: AnyObject]] {
                self.handleSuccess(dictionary)
            } else {
                self.handleFailure(nil)
            }
        }
        
        let failureBlock = { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            self.handleFailure(error)
        }
        
        var contentTypes = Set<String>()
        contentTypes.insert("text/html")
        self.manager.responseSerializer.acceptableContentTypes = contentTypes
        self.request = self.manager.GET(urlString, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
    }
    
    func handleSuccess(response: [[String: AnyObject]]!) {
        FSLocalStorage.sharedInstance.createContext { (context) in
            let existMovies = FSLocalStorage.sharedInstance.movies(withPredicate: NSPredicate(format: "source = %d", FSMovie.SourceFsTo), fromContext: context)
            let existCountries = FSLocalStorage.sharedInstance.allCountries(fromContext: context)
            let existYears = FSLocalStorage.sharedInstance.allYears(fromContext: context)
            let existGenres = FSLocalStorage.sharedInstance.allGenres(fromContext: context)
            
            var searchResults = [FSMovie]()
            for movieInfo in response {
                let section = movieInfo["section"] as! String
                guard section == "video" else {
                    continue
                }
                let link = movieInfo["link"] as! String
                var movieId = NSURL(string: link)!.lastPathComponent
                let separatorPosition = movieId!.rangeOfString("-")
                movieId = movieId!.substringToIndex((separatorPosition?.startIndex)!)
                
                var movie = existMovies.filter({ (it: FSMovie) -> Bool in
                    it.movieId == movieId
                }).first
                
                if nil == movie {
                    movie = FSLocalStorage.sharedInstance.insertMovie(inContext: context)
                    movie!.movieId = movieId
                    movie!.link = link
                    movie!.source = FSMovie.SourceFsTo
                }
                
                let poster = movieInfo["poster"] as! String
                var posterURL = NSURL(string: "http:" + poster)
                let lastComponent = posterURL?.lastPathComponent
                posterURL = posterURL?.URLByDeletingLastPathComponent?.URLByDeletingLastPathComponent
                posterURL = posterURL?.URLByAppendingPathComponent("1").URLByAppendingPathComponent(lastComponent!)
                movie!.poster = posterURL?.absoluteString
                
                movie!.section = movieInfo["subsection"] as? String
                movie!.title = movieInfo["title"] as? String
                
                if let countryInfos = movieInfo["country"] as? [String] {
                    for name in countryInfos {
                        var country = existCountries.filter({ (it: FSCountry) -> Bool in
                            it.name == name
                        }).first
                        if nil == country {
                            country = FSLocalStorage.sharedInstance.insertCountry(inContext: context)
                            country?.name = name
                        }
                        movie!.addCountriesValue(country!)
                    }
                }
                
                if let genreInfos = movieInfo["genres"] as? [String] {
                    for name in genreInfos {
                        var genre = existGenres.filter({ (it: FSGenre) -> Bool in
                            it.name == name
                        }).first
                        if nil == genre {
                            genre = FSLocalStorage.sharedInstance.insertGenre(inContext: context)
                            genre?.name = name
                        }
                        movie!.addGenresValue(genre!)
                    }
                }
                
                if let yearInfos = movieInfo["year"] as? [String] {
                    for stringYear in yearInfos {
                        let intYear = Int32(stringYear)
                        var year = existYears.filter({ (it: FSYear) -> Bool in
                            it.year == intYear
                        }).first
                        if nil == year {
                            year = FSLocalStorage.sharedInstance.insertYear(inContext: context)
                            year?.year = intYear!
                        }
                        movie!.addYearsValue(year!)
                    }
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
    
    override func cancel() {
        super.cancel()
        self.request?.cancel()
    }
}
