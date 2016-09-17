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
    private let memory: LexisPersistence = MemoryPersistence()
    private let persisted: LexisPersistence = UserDefaultsPersistence.instance!
    
    private init()
    {
        var words = persisted.getAllWords()
        
        if words.isEmpty
        {
            words = LexisEngine.instance.getAllWords()
            do
            {
                try persisted.save(words: words)
            }
            catch
            {
                LOG.error("Failed to persist Lexis Words: \(error)")
            }
        }
        
        LOG.info("Loaded \(words.count) words")
        
        do
        {
            try memory.save(words: words)
            LOG.info("Persisted words in database")
        }
        catch let ex
        {
            LOG.error("Failed to save words in memory: \(ex)")
        }
    }
    

    public var anyWord: LexisWord
    {
        return memory.getAllWords().anyElement!
    }
    
    public func findWord(withTerm term: String) -> [LexisWord]
    {
        return memory.searchForWords(inWordList: term)
    }
    
}
