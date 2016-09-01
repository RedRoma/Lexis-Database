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
    
    var notEmpty: Bool {
        return !isEmpty
    }
    
    typealias Expression = ((number: Int, text: String)) -> ()
    
    
    func forEachLine(_ expression: Expression)
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
}
