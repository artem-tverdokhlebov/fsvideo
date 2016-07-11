//
//  FSWebServices.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/11/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import UIKit

class FSWebServices: NSObject {
    
    static let sharedInstance = FSWebServices()
    
    func search(searchQuery: String, source: Int32, success: FSSearchRequestClosureSuccess?, failure: FSClosureFailure?) -> FSWebRequest {
        if source == FSMovie.SourceExUa {
            return EXSearchRequest(searchQuery: searchQuery, success: success, failure: failure)
        } else {
            return FSSearchRequest(searchQuery: searchQuery, success: success, failure: failure)
        }
    }
    
    func folderContent(movie: FSMovie, folder: FSFolder?, success: FSFoldersRequestClosureSuccess?, failure: FSClosureFailure?) -> FSWebRequest {
        assert(movie.source == FSMovie.SourceFsTo)
        return FSFoldersRequest(movie: movie, folder: folder, success: success, failure: failure)
    }

    func fileUrl(movie: FSMovie, file: FSFile, success: FSClosureSuccess?, failure: FSClosureFailure?) -> FSWebRequest {
        if movie.fromExUa {
            return EXFileURLRequest(file: file, success: success, failure: failure)
        } else {
            return FSFileURLRequest(movie: movie, file: file, success: success, failure: failure)
        }
    }
    
    func reviews(movie: FSMovie, offset: UInt, success: FSReviewsRequestClosureSuccess?, failure: FSClosureFailure?) -> FSWebRequest {
        if movie.fromExUa {
            return EXReviewsRequest(movie: movie, page: offset, success: success, failure: failure)
        } else {
            return FSReviewsRequest(movie: movie, offset: offset, success: success, failure: failure)
        }
    }
    
    func movieInfo(movie: FSMovie, success: FSClosureSuccess?, failure: FSClosureFailure?) -> FSWebRequest {
        if movie.fromExUa {
            return EXMovieInfoRequest(movie: movie, success: success, failure: failure)
        } else {
            return FSFileURLRequest(movie: movie, file: nil, success: success, failure: failure)
        }
    }
}
