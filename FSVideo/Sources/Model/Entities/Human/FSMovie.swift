//
//  FSMovie.swift
//
//  Created by Alexey Bodnya on 04/11/16.
//  Copyright (c) 2016 Alexey Bodnya. All rights reserved.
//

import Foundation
import CoreData

class FSMovie: FSMovieMachine, FSDatabaseEntity {
    
    static let SourceFsTo: Int32 = 0
    static let SourceExUa: Int32 = 1
    
    class func uniqueFieldKeyPath() -> String {
        return "movieId"
    }
    
    var host: String {
        return self.fromExUa ? FSWebRequest.exHost : FSWebRequest.fsHost
    }
    
    var fromExUa: Bool {
        return source == FSMovie.SourceExUa
    }
}
