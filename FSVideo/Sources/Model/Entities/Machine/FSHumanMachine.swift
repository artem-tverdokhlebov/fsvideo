//
//  FSHumanMachine.swift
//
//  Created by Alexey Bodnya on 05/06/16.
//  Copyright (c) 2016 Alexey Bodnya. All rights reserved.
//

import Foundation
import CoreData


class FSHumanMachine: NSManagedObject {

    @NSManaged var link: String?
    @NSManaged var name: String?
    @NSManaged var casted: NSSet
    @NSManaged var directed: NSSet
 
    func addCastedValue(value: FSMovie) {
        let items = self.mutableSetValueForKey("casted");
        items.addObject(value)
    }

    func removeCastedValue(value: FSMovie) {
        let items = self.mutableSetValueForKey("casted");
        items.removeObject(value)
    }


    func addDirectedValue(value: FSMovie) {
        let items = self.mutableSetValueForKey("directed");
        items.addObject(value)
    }

    func removeDirectedValue(value: FSMovie) {
        let items = self.mutableSetValueForKey("directed");
        items.removeObject(value)
    }


}
