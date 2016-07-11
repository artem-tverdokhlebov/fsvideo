//
//  FSItemLinkResolver.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/17/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit
import CocoaLumberjack

#if EXTENDED
    import TCBlobDownloadSwift
    let kFSDidFinishedDownloadNotification = "finishedDownload"
#endif

class FSItemLinkResolver: NSObject {

    static let sharedInstance = FSItemLinkResolver()
    
    var linkInfos = [String : FSItemLinkInfo]()
    let documentsFolder = NSURL.documents()
    
    #if EXTENDED
    var manager: TCBlobDownloadManager!
    var bacgroundSessionConfiguration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("dev.abodnya.fsvideo")
    
    override init() {
        super.init()
        self.configureManager()
    }
    
    func configureManager() {
        var config: NSURLSessionConfiguration!
        if FSProxyConfiguration.isNeedProxy {
            config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
            config.connectionProxyDictionary = FSProxyConfiguration.config
        } else {
            config = bacgroundSessionConfiguration
        }
        self.manager = TCBlobDownloadManager(config: config)
        self.manager.allowRedirection = FSProxyConfiguration.isNeedProxy
    }
    
    func downloadFile(file: FSFile, progress: FSDownloadProgressClosure?, success: FSDownloadSuccessClosure?, failure: FSDownloadFailureClosure?) {
        guard file.fileName != nil && file.movie?.title != nil else {
            failure?(error: NSError(domain: "dev.abodnya.fsvideo", code: -1, userInfo: nil))
            return
        }
        print("downloadFile " + file.fileName! + " from movie " + file.movie!.title!)
        let fileName = file.localURL.lastPathComponent!
        var linkInfo = self.linkInfos[fileName]
        if nil == linkInfo {
            print("create new downloading")
            linkInfo = FSItemLinkInfo(file: file)
            linkInfo?.progress = progress
            linkInfo?.success = success
            linkInfo?.failure = failure
            self.linkInfos[fileName] = linkInfo
            self.fetchLink(file, force: true, success: {
                let request = self.requestForDownloadingFile(file)
                linkInfo?.download = self.manager.downloadFileWithRequest(request, toDirectory: self.documentsFolder, withName: fileName, andDelegate: self)
            }, failure: { (error) in
                self.linkInfos[file.fileName!] = nil
                failure?(error: error)
            })
        }
    }
    
    func requestForDownloadingFile(file: FSFile) -> NSURLRequest! {
        let request = NSMutableURLRequest(URL: file.onlineURL!)
        if file.movie!.fromExUa {
            request.setValue("AppleCoreMedia/1.0.0.13E238 (iPhone; U; CPU OS 9_3_1 like Mac OS X; en_us)", forHTTPHeaderField: "User-Agent")
            request.setValue("rover.info", forHTTPHeaderField: "Host")
        }
        return request
    }
    
    func cancel(file: FSFile) {
        let fileName = file.localURL.lastPathComponent!
        if let linkInfo = self.linkInfos[fileName] {
            linkInfo.download?.delegate = nil
            linkInfo.download?.cancel()
            self.linkInfos.removeValueForKey(fileName)
        }
    }
    #endif
    
    func fetchLink(file: FSFile, force: Bool, success: () -> Void, failure: FSClosureFailure?) {
        let fileName = file.localURL.lastPathComponent!
        var linkInfo = self.linkInfos[fileName]
        print("fetchLink " + file.fileName! + " from movie " + file.movie!.title!)
        if nil == file.url || force {
            var resetAfterFetch = false
            if nil == linkInfo {
                resetAfterFetch = true
                linkInfo = FSItemLinkInfo(file: file)
            }
            linkInfo?.fetchOperation = FSWebServices.sharedInstance.fileUrl(file.movie!, file: file, success: {
                if resetAfterFetch {
                    self.linkInfos.removeValueForKey(fileName)
                }
                linkInfo?.fetchOperation = nil
                print("link fetched: " + file.url!)
                success()
            }, failure: { (error) in
                if resetAfterFetch {
                    self.linkInfos.removeValueForKey(fileName)
                }
                linkInfo?.fetchOperation = nil
                print("link fetch failed: " + error.description)
                failure?(error: error)
            })
        } else {
            print("link existed or non-forced: " + file.url!)
            success()
        }
    }
}

#if EXTENDED
extension FSItemLinkResolver: TCBlobDownloadDelegate {
    
    func download(download: TCBlobDownload, didProgress progress: Float, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let download = self.linkInfos[download.fileName!]
        download?.progress?(progress: progress, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
    }
    
    func download(download: TCBlobDownload, didFinishWithError error: NSError?, atLocation location: NSURL?) {
        let linkInfo = self.linkInfos[download.fileName!]
        let file = linkInfo!.file
        var retry = false
        if nil != error {
            print("downloading failed with error " + error!.description)
            if error!.domain == NSPOSIXErrorDomain && error!.code == 54 && linkInfo!.retryCount < linkInfo!.maxRetryCount {
                linkInfo!.retryCount += 1
                print("Retry")
                retry = true
            } else if error!.code == 404 && !(linkInfo!.didHandleOldLink) {
                file.url = nil
                linkInfo!.didHandleOldLink = true
                FSLocalStorage.sharedInstance.saveChanges(file.managedObjectContext!)
                retry = true
            } else {
                linkInfo?.failure?(error: error!)
            }
        } else {
            print("downloading succeded with url: " + file.localURL.absoluteString)
            location?.excludeFromBackup()
            file.isExtended = true
            FSLocalStorage.sharedInstance.saveChanges(file.managedObjectContext!)
            linkInfo?.success?(location: location!)
        }
        self.linkInfos.removeValueForKey(download.fileName!)
        if retry {
            self.downloadFile(file, progress: linkInfo?.progress, success: linkInfo?.success, failure: linkInfo?.failure)
        }
        NSNotificationCenter.defaultCenter().postNotificationName(kFSDidFinishedDownloadNotification, object: self)
    }
}
#endif
