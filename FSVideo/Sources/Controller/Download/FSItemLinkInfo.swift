//
//  FSItemLinkInfo.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/17/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit

#if EXTENDED
    import TCBlobDownloadSwift
    
    typealias FSDownloadProgressClosure = (progress: Float, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) -> Void
    typealias FSDownloadSuccessClosure = (location: NSURL) -> Void
    typealias FSDownloadFailureClosure = FSClosureFailure
#endif


class FSItemLinkInfo: NSObject {
    
    #if EXTENDED
    var download: TCBlobDownload?
    var progress: FSDownloadProgressClosure?
    var failure: FSDownloadFailureClosure?
    var success: FSDownloadSuccessClosure?
    
    var retryCount = 0
    let maxRetryCount = 5
    #endif
    
    var fetchOperation: FSWebRequest?
    var file: FSFile
    var didHandleOldLink = false
    
    init(file: FSFile) {
        self.file = file
    }
}
