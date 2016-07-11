//
//  FSFoldersRequest.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/12/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit
import CoreData
import AFNetworking
import Fuzi
import NSURL_QueryDictionary


typealias FSFoldersRequestClosureSuccess = (folders: [FSFolder], files: [FSFile]) -> Void

class FSFoldersRequest: FSWebRequest {
    
    var request: NSURLSessionDataTask?
    var success: FSFoldersRequestClosureSuccess?
    var movie: FSMovie
    var folder: FSFolder?
    
    init(movie: FSMovie, folder: FSFolder?, success: FSFoldersRequestClosureSuccess?, failure: FSClosureFailure?) {
        self.movie = movie
        super.init(failure: failure)
        self.success = success
        self.folder = folder
        send()
    }
    
    override func send() {        
        let urlString = FSWebRequest.fsHost + movie.link! + "?ajax"
        let parameters = ["folder" : nil != folder ? folder!.folderId! : "0"]
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
            let ulNodes = document.xpath("//body").first!.children.filter({ (ul) -> Bool in
                ul.tag == "ul"
            }) as [XMLElement]
            var listNodes = [XMLElement]()
            for ul in ulNodes {
                let liNodes = ul.children.filter({ (li) -> Bool in
                    li.tag == "li"
                })
                listNodes.appendContentsOf(liNodes)
            }
            let movie = context.objectWithID(self.movie.objectID) as! FSMovie
            let rootFolder = nil != self.folder ? context.objectWithID(self.folder!.objectID) as? FSFolder : nil
            let existFolders = (nil != rootFolder ? rootFolder?.children : movie.folders)?.allObjects as! [FSFolder]
            
            var folders = [FSFolder]()
            var files = [FSFile]()
            
            for listNode in listNodes {
                let nodeClasses = listNode.attr("class")?.componentsSeparatedByString(" ")
                if nodeClasses!.contains("folder") {
                    let folder = self.parseFolderTag(listNode, classes: nodeClasses!, movie: movie, rootFolder: rootFolder, existFolders: existFolders)
                    folders.append(folder)
                } else {
                    if let file = self.parseFileTag(listNode, classes: nodeClasses!, folder: rootFolder) {
                        files.append(file)
                    }
                }
            }
            
            FSLocalStorage.sharedInstance.saveChanges(context)
            FSLocalStorage.sharedInstance.removeContext(context)
            if !self.isCancelled {
                dispatch_async(dispatch_get_main_queue(), {
                    let mainContext = FSLocalStorage.sharedInstance.mainObjectContext
                    let foldersInMainContext = folders.map({ (it) -> FSFolder in
                        return mainContext.objectWithID(it.objectID) as! FSFolder
                    })
                    let filesInMainContext = files.map({ (it) -> FSFile in
                        return mainContext.objectWithID(it.objectID) as! FSFile
                    })
                    self.success?(folders: foldersInMainContext, files: filesInMainContext)
                })
            }
        }
    }
    
    func parseFolderTag(listNode: XMLElement, classes: [String], movie: FSMovie, rootFolder: FSFolder?, existFolders: [FSFolder]) -> FSFolder {
        
        let context = movie.managedObjectContext
        let link = listNode.xpath("div/a").first!
        let relationshipJson = link.attr("rel")?.replaced([
            "'": "\"",
            "parent_id": "\"parent_id\"",
            "series_list": "\"series_list\"",
            "quality_list": "\"quality_list\""
        ])
        let relationshipData = relationshipJson?.dataUsingEncoding(NSUTF8StringEncoding)
        let relationship = try! NSJSONSerialization.JSONObjectWithData(relationshipData!, options: NSJSONReadingOptions.AllowFragments)
        
        let folderId = relationship["parent_id"] as! String
        var folder = existFolders.filter({ (it: FSFolder) -> Bool in
            return it.folderId == folderId
        }).first
        if nil == folder {
            folder = FSLocalStorage.sharedInstance.insertFolder(inContext: context)
            folder?.folderId = folderId
            if nil != rootFolder {
                rootFolder?.addChildrenValue(folder!)
                folder?.movie = movie
            } else {
                movie.addFoldersValue(folder!)
            }
        }
        folder!.name = link.stringValue.trimmedWhitespace()
        
        let spans = listNode.xpath("span")
        let dateSpan = spans.filter { (it: XMLElement) -> Bool in
            return it.attr("class") == "material-date"
        }.first
        folder?.updateDateString = dateSpan?.stringValue.trimmedWhitespace()
        folder?.details = spans.first?.stringValue.trimmedWhitespace()
        if nil != folder?.updateDateString {
            folder!.updateDate = FSWebRequest.fsDateFormatter().dateFromString(folder!.updateDateString!)
        }
        
        return folder!
    }
    
    func parseFileTag(listNode: XMLElement, classes: [String], folder: FSFolder?) -> FSFile? {
        
        let context = folder!.managedObjectContext
        let links = listNode.xpath("a")
        
        let link = links.first
        guard link != nil else {
            return nil
        }
        let linkId = link!.attr("id")
        guard linkId == nil || !linkId!.hasPrefix("dl_") else {
            // File hasn't been uploaded yet
            return nil
        }
        let urlString = FSWebRequest.fsHost + link!.attr("href")!
        let linkParameters = NSURL(string: urlString)!.uq_queryDictionary()
        let fileId = linkParameters["file"] as! String
        
        let existFiles = folder?.files as? Set<FSFile>
        var file = existFiles?.filter { (it: FSFile) -> Bool in
            return it.fileId == fileId
        }.first
        
        if nil == file {
            file = FSLocalStorage.sharedInstance.insertFile(inContext: context)
            file?.fileId = fileId
            file?.isExtended = false
            file?.movie = folder?.movie
            file?.duration = -1
            file?.fileSize = -1
        }
        
        let spans = link!.xpath("span/span")
        for span in spans {
            if span.attr("class") == "b-file-new__link-material-filename-text" {
                file?.fileName = span.stringValue
            } else if span.attr("class") == "b-file-new__link-material-filename-series-num" {
                file?.seriesNumberString = span.stringValue
            }
        }
        
        let qualitySpan = listNode.xpath("span").first
        file?.quality = qualitySpan?.stringValue
        
        let downloadLink = links[links.count - 1]
        file?.originalFileLink = downloadLink?.attr("href")
        file?.folder = folder
        
        return file!
    }
    
    override func cancel() {
        super.cancel()
        self.request?.cancel()
    }
}
