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
    private var initialized = false
    
    private init()
    {
        
    }
    
    public func initialize()
    {
        guard !initialized else { return }
        initialized = true
        
        LOG.debug("Initializing LexisDatabase")
        
        var words = persisted.getAllWords()
        
        if words.isEmpty
        {
            LOG.warn("No words found persisted. Recreating cache.")
            
            words = LexisEngine.instance.getAllWords()
            
            LOG.debug("Retrieved \(words.count) words")
            do
            {
                try persisted.save(words: words)
                LOG.debug("Persisted \(words.count) words")
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
            LOG.info("Stored \(words.count) words in memory")
        }
        catch let ex
        {
            LOG.error("Failed to save words in memory: \(ex)")
        }
        
    }

    public var anyWord: LexisWord
    {
        if !initialized
        {
            initialize()
        }
        
        return memory.getAllWords().anyElement!
    }
    
    public func findWord(withTerm term: String) -> [LexisWord]
    {
        if !initialized
        {
            initialize()
        }
        
        return memory.searchForWords(inWordList: term)
    }
    
}
