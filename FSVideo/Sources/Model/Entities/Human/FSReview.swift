//
//  FSReview.swift
//
//  Created by Alexey Bodnya on 04/13/16.
//  Copyright (c) 2016 Alexey Bodnya. All rights reserved.
//

import Foundation
import CoreData

class FSReview: FSReviewMachine, FSDatabaseEntity {

    class func uniqueFieldKeyPath() -> String {
        return "commentId"
    }
}
