//
//  FSDatabaseEntity.swift
//
//  Created by Alexey Bodnya on 04/11/16.
//  Copyright (c) 2016 Alexey Bodnya. All rights reserved.
//

import Foundation


protocol FSDatabaseEntity {
    static func uniqueFieldKeyPath() -> String
}
