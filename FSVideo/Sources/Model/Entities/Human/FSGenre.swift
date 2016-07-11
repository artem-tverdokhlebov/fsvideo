//
//  FSGenre.swift
//
//  Created by Alexey Bodnya on 04/11/16.
//  Copyright (c) 2016 Alexey Bodnya. All rights reserved.
//

import Foundation
import CoreData

class FSGenre: FSGenreMachine, FSDatabaseEntity {
    
    class func uniqueFieldKeyPath() -> String {
        return "name"
    }
}
