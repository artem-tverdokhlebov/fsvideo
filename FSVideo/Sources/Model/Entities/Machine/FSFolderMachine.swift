//
//  FSFolderMachine.swift
//
//  Created by Alexey Bodnya on 05/06/16.
//  Copyright (c) 2016 Alexey Bodnya. All rights reserved.
//

import Foundation
import CoreData


class FSFolderMachine: NSManagedObject {

    @NSManaged var details: String?
    @NSManaged var folderId: String?
    @NSManaged var name: String?
    @NSManaged var updateDate: NSDate?
    @NSManaged var updateDateString: String?
    @NSManaged var children: NSSet
    @NSManaged var files: NSSet
    @NSManaged var movie: FSMovie?
    @NSManaged var parent: FSFolder?
 
    func addChildrenValue(value: FSFolder) {
        let items = self.mutableSetValueForKey("children");
        items.addObject(value)
    }

    func removeChildrenValue(value: FSFolder) {
        let items = self.mutableSetValueForKey("children");
        items.removeObject(value)
    }


    func addFilesValue(value: FSFile) {
        let items = self.mutableSetValueForKey("files");
        items.addObject(value)
    }

    func removeFilesValue(value: FSFile) {
        let items = self.mutableSetValueForKey("files");
        items.removeObject(value)
    }


}
