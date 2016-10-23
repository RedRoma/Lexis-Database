//
//  Extensions.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 8/27/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation

extension String
{
    
    var notEmpty: Bool
    {
        return !isEmpty
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
    
    /**
        This functional approach runs
     */
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
    
    /**
        Determiens whether the String contains all of the provided substrings.
    */
    func containsAll(_ strings: [String]) -> Bool
    {
        guard strings.notEmpty else { return false }
        
        return strings
            .filter() { self.contains($0) }
            .count == strings.count

    }
    
    func doesNotContain(anyOf strings: [String]) -> Bool
    {
        return strings
            .filter() { self.contains($0) }
            .isEmpty
    }
    
    func toURL() -> URL?
    {
        return URL(string: self)
    }
    
    func substring(from: Int, to: Int) -> String
    {
        let start = index(startIndex, offsetBy: from)
        let end = index(startIndex, offsetBy: to)
        
        let range = Range(uncheckedBounds: (lower: start, upper: end))
        
        return substring(with: range)
    }
    
    func firstHalf() -> String
    {
        let halfPoint = characters.count / 2
        
        return substring(from: 0, to: halfPoint)
    }
}
