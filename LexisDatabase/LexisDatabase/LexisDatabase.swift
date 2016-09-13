//
//  LexisDatabase.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 8/27/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
import Sulcus

/**
    This is the API to the Lexis Database of Latin Words.
    This Dictionary is based off the [Whitaker](http://archives.nd.edu/whitaker/wordsdoc.htm#DICTIONARY) dictionary. **Many** thanks to him for compiling it.
 */
public class LexisDatabase
{
   
    public static let instance = LexisDatabase()
    
    
    /**
        The Persistence Layer
     */
    private let database: LexisPersistence = MemoryPersistence()
    
    private init()
    {
        let words = LexisEngine.instance.getAllWords()
        LOG.info("Loaded \(words.count) words")
        
        do
        {
            try database.save(words: words)
            LOG.info("Persisted words in database")
        }
        catch let ex
        {
            LOG.error("Failed to persist words in Database: \(ex)")
        }
    }
    

    public var anyWord: LexisWord
    {
        return database.getAllWords().anyElement!
    }
    
    public func findWord(withTerm term: String) -> [LexisWord]
    {
        
        return database.searchForWords(inWordList: term)
    }
    
}
