//
//  Extensions.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 8/27/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation

internal extension String
{
    
    var urlEncoded: String?
    {
        return addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
    }
    
    static func isNotEmpty(string: String) -> Bool
    {
        return string.notEmpty
    }

    typealias Expression = ((number: Int, text: String)) -> ()
    func forEachLine(_ expression: @escaping Expression)
    {
        var lineNumber = 0
        //Unsure what that second Boolean argument is for.
        self.enumerateLines() { string, someBoolean in
            lineNumber += 1
            expression((number: lineNumber , text: string))
        }
    }

    func processEachLine<T>(mapper: @escaping (String, Int) -> (T?), processor: @escaping (T) -> ())
    {
        var lineNumber = 0
        self.enumerateLines() { line, someBoolean in
            
            lineNumber += 1
            if let object = mapper(line, lineNumber)
            {
                processor(object)
            }
            
        }
    }
    
    func withCharacterRemoved(character: Character) -> String
    {
        return self.replacingOccurrences(of: "\(character)", with: "")
    }

    /// Determines whether the String contains all of the provided substrings.
    func containsAll(_ strings: [String]) -> Bool
    {
        guard strings.notEmpty else { return false }
        
        return strings.filter() { self.contains($0) }
                      .count == strings.count

    }
    
    func doesNotContain(anyOf strings: [String]) -> Bool
    {
        return strings
            .filter() { self.contains($0) }
            .isEmpty
    }

    func substring(from: Int, to: Int) -> String
    {
        let start = index(startIndex, offsetBy: from)
        let end = index(startIndex, offsetBy: to)
        
        return String(self[start...end])
    }
    
    func firstHalf() -> String
    {
        let halfPoint = count / 2
        
        return substring(from: 0, to: halfPoint)
    }
}
