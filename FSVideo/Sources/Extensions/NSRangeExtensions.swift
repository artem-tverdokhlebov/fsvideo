//
//  NSRangeExtensions.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 7/3/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import Foundation

extension NSRange {
    func toRange(string: String) -> Range<String.Index> {
        let startIndex = string.startIndex.advancedBy(location)
        let endIndex = startIndex.advancedBy(length)
        return startIndex..<endIndex
    }
}
