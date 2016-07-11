//
//  SetExtensions.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/13/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import Foundation


extension Set {
    
    mutating func insertFrom(array: [Element]) {
        for item in array {
            self.insert(item)
        }
    }
    
    mutating func insertFrom(set: Set<Element>) {
        for item in set {
            self.insert(item)
        }
    }
}
