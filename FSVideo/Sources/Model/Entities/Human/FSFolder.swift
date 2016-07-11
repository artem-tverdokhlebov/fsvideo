//
//  FSFolder.swift
//
//  Created by Alexey Bodnya on 04/12/16.
//  Copyright (c) 2016 Alexey Bodnya. All rights reserved.
//

import Foundation
import CoreData

class FSFolder: FSFolderMachine, FSDatabaseEntity {
    
    class func uniqueFieldKeyPath() -> String {
        return "name"
    }
}
