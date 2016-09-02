//
//  LexisDatabase.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 8/27/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation

/**
    This is the API to the Lexis Database of Latin Words.
    This Dictionary is based off the [Whitaker](http://archives.nd.edu/whitaker/wordsdoc.htm#DICTIONARY) dictionary. **Many** thanks to him for compiling it.
 */
public class LexisDatabase
{
    /**
        An in-memory store of all of the Lexis Words.
    */
    public static let words: [LexisWord] = LexisEngine.instance.readAllWords()
    
    
    public static func findWord(withTerm term: String) -> [LexisWord]
    {
        
        return []
    }
    
}
