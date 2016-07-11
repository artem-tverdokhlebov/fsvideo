//
//  FSFileURLRequest.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/13/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit
import AFNetworking
import CoreData


class FSFileURLRequest: FSWebRequest {
    
    var request: NSURLSessionDataTask?
    var success: FSClosureSuccess?
    var file: FSFile?
    var movie: FSMovie?
    
    init(movie: FSMovie, file: FSFile?, success: FSClosureSuccess?, failure: FSClosureFailure?) {
        super.init(failure: failure)
        self.success = success
        self.file = file
        self.movie = movie
        send()
    }
    
    override func send() {
        var urlString = FSWebRequest.fsHost + "/video/serials/view_iframe/" + self.movie!.movieId!
        if nil != file {
            urlString += "?play"
        }
        let parameters: [String: AnyObject]? = nil != file ? ["file" : file!.fileId!] : nil
        let successBlock = { (task: NSURLSessionDataTask, responseObject: AnyObject?) -> Void in
            if let dictionary = responseObject as? [String: AnyObject] {
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
        self.manager.requestSerializer.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        self.request = self.manager.GET(urlString, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
    }
    
    func handleSuccess(response: [String: AnyObject]) {
        FSLocalStorage.sharedInstance.createContext { (context) in
            let evaluatedFile: FSFile? = nil != self.file ? context.objectWithID(self.file!.objectID) as? FSFile : nil
            if nil != evaluatedFile {
                self.handleAsFileURL(response, evaluatedFile: evaluatedFile!, context: context)
            }
            
            let evaluatedMovie = context.objectWithID(self.movie!.objectID) as! FSMovie
            self.handleAsMovieInfo(response, evaluatedMovie: evaluatedMovie, context: context)
            
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

extension FSFileURLRequest {
    
    func handleAsMovieInfo(response: [String: AnyObject]!, evaluatedMovie: FSMovie, context: NSManagedObjectContext) {
        let existHuman = FSLocalStorage.sharedInstance.allHumans(fromContext: context)
        let existYears = FSLocalStorage.sharedInstance.allYears(fromContext: context)
        let existCountries = FSLocalStorage.sharedInstance.allCountries(fromContext: context)
        let existGenres = FSLocalStorage.sharedInstance.allGenres(fromContext: context)
        let existImages = evaluatedMovie.images.allObjects as! [FSImage]
        
        evaluatedMovie.lastUsedDate = NSDate()
        
        // Description
        let player = response["player"] as? [String: AnyObject]
        let tags = player?["tags"] as? [String: AnyObject]
        evaluatedMovie.movieDescription = tags?["description"] as? String
        
        let coverData = response["coverData"] as? [String: AnyObject]
        
        // Years
        let viewPeriod = coverData?["view_period"] as? [String: AnyObject]
        let showStart = viewPeriod?["show_start"] as? [String: AnyObject]
        let showEnd = viewPeriod?["show_end"] as? [String: AnyObject]
        self.fillYearWithInfo(showStart, context: context, movie: evaluatedMovie, existYears: existYears)
        self.fillYearWithInfo(showEnd, context: context, movie: evaluatedMovie, existYears: existYears)
        
        // Screens
        if let bigScreen = coverData?["screens_bg"] as? String {
            evaluatedMovie.screen = "http:" + bigScreen
        }
        
        if let screens = coverData?["screens"] as? [[String: AnyObject]] {
            for screenInfo in screens {
                if let url = screenInfo["url2"] as? String {
                    let link = "http:" + url
                    var image = existImages.filter({ (it) -> Bool in
                        it.link == link
                    }).first
                    
                    if nil == image {
                        image = FSLocalStorage.sharedInstance.insertImage(inContext: context)
                        image!.link = link
                        evaluatedMovie.addImagesValue(image!)
                    }
                }
            }
        }
        
        if evaluatedMovie.screen == nil {
            let screen = evaluatedMovie.images.anyObject() as? FSImage
            evaluatedMovie.screen = screen?.link
        }
        
        // Countries
        if let countries = coverData?["made_in"] as? [[String: AnyObject]] {
            for countryInfo in countries {
                if let name = countryInfo["title"] as? String {
                    var country = existCountries.filter({ (it) -> Bool in
                        it.name == name
                    }).first
                    
                    if nil == country {
                        country = FSLocalStorage.sharedInstance.insertCountry(inContext: context)
                        country!.name = name
                    }
                    
                    evaluatedMovie.addCountriesValue(country!)
                    country!.code = countryInfo["img"] as? String
                }
            }
        }
        
        // Director
        if let directors = coverData?["director"] as? [[String: AnyObject]] {
            for humanInfo in directors {
                if let name = humanInfo["title"] as? String {
                    var human = existHuman.filter({ (it) -> Bool in
                        it.name == name
                    }).first
                    
                    if nil == human {
                        human = FSLocalStorage.sharedInstance.insertHuman(inContext: context)
                        human!.name = name
                    }
                    human!.link = humanInfo["link"] as? String
                    
                    evaluatedMovie.addDirectorsValue(human!)
                }
            }
        }
        
        // Actors
        if let cast = coverData?["cast"] as? [[String: AnyObject]] {
            for humanInfo in cast {
                if let name = humanInfo["title"] as? String {
                    var human = existHuman.filter({ (it) -> Bool in
                        it.name == name
                    }).first
                    
                    if nil == human {
                        human = FSLocalStorage.sharedInstance.insertHuman(inContext: context)
                        human!.name = name
                    }
                    human!.link = humanInfo["link"] as? String
                    
                    evaluatedMovie.addCastValue(human!)
                }
            }
        }
        
        // Genres
        if let genres = coverData?["genre"] as? [[String: AnyObject]] {
            for genreInfo in genres {
                if let name = genreInfo["title"] as? String {
                    var genre = existGenres.filter({ (it) -> Bool in
                        it.name == name
                    }).first
                    
                    if nil == genre {
                        genre = FSLocalStorage.sharedInstance.insertGenre(inContext: context)
                        genre?.name = name
                    }
                    genre!.link = genreInfo["link"] as? String
                    
                    evaluatedMovie.addGenresValue(genre!)
                }
            }
        }
    }
    
    
    func fillYearWithInfo(info: [String: AnyObject]?, context: NSManagedObjectContext, movie: FSMovie, existYears: [FSYear]) -> FSYear? {
        if let yearString = info?["title"]?.stringByReplacingOccurrencesOfString("+", withString: "") {
            if let yearInt = Int32(yearString) {
                var year = existYears.filter({ (it: FSYear) -> Bool in
                    it.year == yearInt
                }).first
                
                if nil == year {
                    year = FSLocalStorage.sharedInstance.insertYear(inContext: context)
                    year!.year = yearInt
                }
                
                year!.link = info?["link"] as? String
                movie.addYearsValue(year!)
                return year
            }
        }
        return nil
    }
}

extension FSFileURLRequest {

    func handleAsFileURL(response: [String: AnyObject], evaluatedFile: FSFile, context: NSManagedObjectContext) {
        let existFiles = evaluatedFile.folder?.files.allObjects as! [FSFile]
        
        let actionsData = response["actionsData"] as! [String: AnyObject]
        
        let fileInfos = actionsData["files"] as! [[String: AnyObject]]
        for (index, fileInfo) in fileInfos.enumerate() {
            let fileId = fileInfo["id"] as! String
            var file = existFiles.filter({ (it: FSFile) -> Bool in
                return it.fileId == fileId
            }).first
            
            if nil == file {
                print("warning: missed file")
                file = FSLocalStorage.sharedInstance.insertFile(inContext: context)
                file?.fileId = fileId
                file?.fileName = fileInfo["file_name"] as? String
                file?.quality = fileInfo["quality"] as? String
            }
            
            file!.sourceOrder = Int32(index)
            file!.url = fileInfo["url"] as? String
            if let seasonValue = fileInfo["season"] as? Int {
                file!.season = Int32(seasonValue)
            }
            if let seriesNumber = fileInfo["series_num"] as? Int {
                file!.seriesNumber = Int32(seriesNumber)
            }
        }
    }
}
