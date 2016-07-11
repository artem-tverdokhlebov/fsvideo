//
//  FSImageMachine.swift
//
//  Created by Alexey Bodnya on 05/06/16.
//  Copyright (c) 2016 Alexey Bodnya. All rights reserved.
//

import Foundation
import CoreData


class FSImageMachine: NSManagedObject {

    @NSManaged var link: String?
    @NSManaged var movie: FSMovie?
 
}
