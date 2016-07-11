//
//  FSSearchQuery.swift
//
//  Created by Alexey Bodnya on 05/03/16.
//  Copyright (c) 2016 Alexey Bodnya. All rights reserved.
//

import Foundation
import CoreData

class FSSearchQuery: FSSearchQueryMachine, FSDatabaseEntity {

    class func uniqueFieldKeyPath() -> String {
        return "searchQuery"
    }
}
