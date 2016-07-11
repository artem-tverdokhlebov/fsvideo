//
//  FSYearMachine.swift
//
//  Created by Alexey Bodnya on 05/06/16.
//  Copyright (c) 2016 Alexey Bodnya. All rights reserved.
//

import Foundation
import CoreData


class FSYearMachine: NSManagedObject {

    @NSManaged var link: String?
    @NSManaged var year: Int32
    @NSManaged var movies: NSSet
 
    func addMoviesValue(value: FSMovie) {
        let items = self.mutableSetValueForKey("movies");
        items.addObject(value)
    }

    func removeMoviesValue(value: FSMovie) {
        let items = self.mutableSetValueForKey("movies");
        items.removeObject(value)
    }


}
