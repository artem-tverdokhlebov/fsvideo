//
//  FSFile.swift
//
//  Created by Alexey Bodnya on 04/11/16.
//  Copyright (c) 2016 Alexey Bodnya. All rights reserved.
//

import Foundation
import CoreData

class FSFile: FSFileMachine, FSDatabaseEntity {
    
    class func uniqueFieldKeyPath() -> String {
        return "fileId"
    }
    
    var localURL: NSURL! {
        var url = NSURL.documents()
        url = url.URLByAppendingPathComponent(self.fileId! + "_" + self.fileName!)
        url = url.URLByDeletingPathExtension!
        url = url.URLByAppendingPathExtension("mp4")
        return url
    }
    
    var onlineURL: NSURL? {
        var url = self.url
        if nil == url {
            return nil
        }
        if self.movie!.source == FSMovie.SourceFsTo {
            url = FSWebRequest.fsHost + url!
        }
        return NSURL(string: url!)!
    }
    
    func delete() {
        self.isExtended = false
        FSLocalStorage.sharedInstance.saveChanges(self.managedObjectContext!)
        do {
            try NSFileManager.defaultManager().removeItemAtURL(self.localURL)
        } catch let error as NSError {
            print("Can't delete file " + error.description)
        }
    }
}
