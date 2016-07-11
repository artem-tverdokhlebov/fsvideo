//
//  XMLElementExtensions.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 5/1/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import Foundation
import Fuzi

extension XMLElement {
    
    var recursiveStringValue: String {
        let buffer = NSMutableString()
        recursiveContent(buffer)
        return buffer as String
    }
    
    func recursiveContent(buffer: NSMutableString) {
        if self.tag == "br" {
            buffer.appendString("\n")
        }
        
        let children = self.xpath("node()")
        if children.count > 0 {
            for node in children {
                node.recursiveContent(buffer)
            }
        } else {
            buffer.appendString(self.stringValue)
        }
    }
}
