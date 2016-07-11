//
//  FSReviewMachine.swift
//
//  Created by Alexey Bodnya on 05/06/16.
//  Copyright (c) 2016 Alexey Bodnya. All rights reserved.
//

import Foundation
import CoreData


class FSReviewMachine: NSManagedObject {

    @NSManaged var authorName: String?
    @NSManaged var comment: String?
    @NSManaged var commentId: String?
    @NSManaged var date: NSDate?
    @NSManaged var dateString: String?
    @NSManaged var dislikes: Int32
    @NSManaged var likes: Int32
    @NSManaged var positive: Bool
    @NSManaged var movie: FSMovie?
 
}
