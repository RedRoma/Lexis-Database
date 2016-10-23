//
//  LexisDatabase.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 8/27/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
import Archeota

/**
    This is the API to the Lexis Database of Latin Words.
    This Dictionary is based off the [Whitaker](http://archives.nd.edu/whitaker/wordsdoc.htm#DICTIONARY) dictionary. **Many** thanks to him for compiling it.
 */
public class LexisDatabase
{
   
    public static let instance = LexisDatabase()
    
    fileprivate let memory: LexisPersistence = MemoryPersistence()
    fileprivate var persisted = FilePersistence.instance
    fileprivate var web = WebRequestPersistence()
    
    fileprivate var initialized = false
    private var initializing = false
    
    private init()
    {
    }
    
    public func initialize()
    {
        guard !initialized else { return }
        
        if initializing
        {
            LOG.info("Already initializing. Blocking until done.")
            waitUntilInitialized()
            return
        }
        
        initializing = true
        
        LOG.debug("Initializing LexisDatabase")
        
        
        initializing = false
        initialized = true
    }

    public var anyWord: LexisWord
    {
        if let word = web.getAnyWord()
        {
            return word
        }
        else
        {
            loadPersisted()
            
            if let word = memory.getAnyWord()
            {
                return word
            }
            else
            {
                return LexisWord.emptyWord
            }
        }
    }
    
    private func loadPersisted()
    {
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
    
    private func waitUntilInitialized()
    {
        
        while !initialized
        {
            let logLevel = LOG.level
            LOG.level = .info
            LOG.debug("Waiting")
            LOG.level = logLevel
        }
    }
    
    fileprivate func saveWordsInMemory(words: [LexisWord])
    {
        var memoryWords = memory.getAllWords()
        
        for word in words
        {
            if !memoryWords.contains(word)
            {
                memoryWords.append(word)
            }
        }
        
        try? memory.save(words: memoryWords)
    }
}


//MARK: Searching
public extension LexisDatabase
{
    public func searchForms(withTerm term: String) -> [LexisWord]
    {
        if !initialized
        {
            initialize()
        }
        
        return web.searchForWordsContaining(term: term)
    }
    
    public func searchForms(startingWith term: String) -> [LexisWord]
    {
        if !initialized
        {
            initialize()
        }
        
        return web.searchForWordsStartingWith(term: term)
    }
    
    public func searchDefinitions(withTerm term: String) -> [LexisWord]
    {
        if !initialized
        {
            initialize()
        }
        
        if let urlEncodedTerms = term.urlEncoded
        {
            return web.searchForWordsInDefinitions(term: urlEncodedTerms)
        }
        
        return memory.searchForWordsInDefinitions(term: term)
    }
}
