//
//  StringExtensions.swift
//  FSVideo
//
//  Created by Alexey Bodnya on 4/11/16.
//  Copyright © 2016 Alexey Bodnya. All rights reserved.
//

import Foundation


extension String {
    
    mutating func appendPath(newPath: String) {
        if self.characters.last != "/" && newPath.characters.first != "/" {
            self += "/"
        }
        self += newPath
    }
    
    func appendedPath(newPath: String) -> String {
        var path = String(self)
        path.appendPath(newPath)
        return path
    }
    
    func replaced(fromToPairs: [String: String]) -> String {
        var result = String(self)
        for (from, to) in fromToPairs {
            result = result.stringByReplacingOccurrencesOfString(from, withString: to)
        }
        return result
    }
    
    func between(from: String, to: String) -> String? {
        let rangeFrom = self.rangeOfString(from)
        guard nil != rangeFrom else {
            return nil
        }
        let rangeTo = self.rangeOfString(to, options: .CaseInsensitiveSearch, range: rangeFrom!.endIndex ..< self.endIndex, locale: nil)
        guard nil != rangeTo else {
            return nil
        }
        let range: Range<Index> = rangeFrom!.endIndex ..< rangeTo!.startIndex
        let substring = self.substringWithRange(range)
        return substring
    }
    
    func trimmedWhitespace() -> String {
        var result = self.replaced(["\t" : "", "\n" : "", "\r" : ""])
        result = result.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        while result.rangeOfString("  ") != nil {
            result = result.stringByReplacingOccurrencesOfString("  ", withString: " ")
        }
        return result
    }
    
    var length: Int {
        get {
            return self.characters.count
        }
    }
    
    static func fromBytes(bytes: Int64) -> String {
        var size = Double(bytes)
        var measureLevel = 0;
        while (size > 1024) {
            size = size / 1024;
            measureLevel = measureLevel + 1;
        }
        
        var sizeMeasureType = ""
        switch (measureLevel) {
            case 0: sizeMeasureType = "B"
            case 1: sizeMeasureType = "KB"
            case 2: sizeMeasureType = "MB"
            case 3: sizeMeasureType = "GB"
            case 4: sizeMeasureType = "TB"
            case 5: sizeMeasureType = "PB"
            default: break
        }
        return String(format: "%.1f\(sizeMeasureType)", size)
    }
    
    #if EXTENDED
    
    func decrypted() -> String {
        if self.length <= 1 {
            return String(self)
        }
        let leftOffset: UInt32 = 13
        let rightOffset: UInt32 = 6
        let middle = self.length / 2
        var replaced = ""
        // replace first part of characters with the same characters, incremented by index leftOffset
        // replace second part of characters with the same characters, incremented by index rightOffset
        for (index, character) in self.characters.enumerate() {
            let scalars = String(character).unicodeScalars
            var scalar = scalars[scalars.startIndex].value
            if index < middle {
                scalar = scalar + leftOffset
            } else {
                scalar = scalar + rightOffset
            }
            let newCharacter = Character(UnicodeScalar(scalar))
            replaced += String(newCharacter)
        }
        
        // replace each 0 character with 1, 2 with 3, and so on
        var result = ""
        var previousCharacter: Character? = replaced.characters.first
        for (index, character) in replaced.characters.enumerate() {
            if index % 2 == 0 {
                result += String(character)
                result += String(previousCharacter)
                previousCharacter = nil
            } else {
                previousCharacter = character
            }
        }
        if nil != previousCharacter {
            result += String(previousCharacter)
        }
        return result
    }
    
    #endif
}
