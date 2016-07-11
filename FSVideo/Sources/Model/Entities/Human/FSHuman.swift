//
//  FSHuman.swift
//
//  Created by Alexey Bodnya on 04/15/16.
//  Copyright (c) 2016 Alexey Bodnya. All rights reserved.
//

import Foundation
import CoreData

class FSHuman: FSHumanMachine, FSDatabaseEntity {

    class func uniqueFieldKeyPath() -> String {
        return "name"
    }
}
