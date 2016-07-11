//
//  FSFileMachine.swift
//
//  Created by Alexey Bodnya on 05/06/16.
//  Copyright (c) 2016 Alexey Bodnya. All rights reserved.
//

import Foundation
import CoreData


class FSFileMachine: NSManagedObject {

    @NSManaged var duration: Double
    @NSManaged var fileId: String?
    @NSManaged var fileName: String?
    @NSManaged var fileSize: Int64
    @NSManaged var isExtended: Bool
    @NSManaged var originalFileLink: String?
    @NSManaged var pauseSecond: Double
    @NSManaged var quality: String?
    @NSManaged var season: Int32
    @NSManaged var seriesNumber: Int32
    @NSManaged var seriesNumberString: String?
    @NSManaged var sourceOrder: Int32
    @NSManaged var url: String?
    @NSManaged var folder: FSFolder?
    @NSManaged var movie: FSMovie?
 
}
