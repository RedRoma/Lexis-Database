//
//  LexisDatabase.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 8/27/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Archeota
import AromaSwiftClient
import Foundation


/**
    This is the API to the Lexis Database of Latin Words.
    This Dictionary is based off the [Whitaker](http://archives.nd.edu/whitaker/wordsdoc.htm#DICTIONARY) dictionary. **Many** thanks to him for compiling it.
 */
public class LexisDatabase
{
   
    public static let instance = LexisDatabase()
    
    fileprivate let async = OperationQueue()
    fileprivate let main = OperationQueue.main
    
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
        LOG.debug("Ignoring depracated initialize() call")
    }

    public var anyWord: LexisWord
    {
        if let word = memory.getAnyWord()
        {
            return word
        }
        else
        {
            startLoadingFromWeb()
            
            let startTime = Date()
            if let word = web.getAnyWord()
            {
                let latency = abs(startTime.timeIntervalSinceNow)
                LOG.debug("Operation to load any word from web took \(latency)s")
                AromaClient.sendLowPriorityMessage(withTitle: "Web Request Complete", withBody: "Operation took \(latency)s")
                
                return word
            }
            else
            {
                AromaClient.sendHighPriorityMessage(withTitle: "Operation Failed", withBody: "Coult not load any word from the Web")
                
                let start = Date()
                self.loadPersisted()
                let delta = abs(start.timeIntervalSinceNow)
                
                AromaClient.sendHighPriorityMessage(withTitle: "Loaded Persisted Dictionary", withBody: "Operation took \(delta)secs")
                
                if let word = self.memory.getAnyWord()
                {
                    AromaClient.sendMediumPriorityMessage(withTitle: "Loaded Persisted Word", withBody: "Sucessfully loaded persisted word: \n\(word)")
                    return word
                }
                else
                {
                    AromaClient.sendHighPriorityMessage(withTitle: "Failed To Load Persisted Word", withBody: "Failed to load a word from the persisted dictionary")
                    return LexisWord.emptyWord
                }
                
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
    
    fileprivate func startLoadingFromWeb()
    {
        guard !initializing , !initialized else { return }
        initializing = true
        
        async.addOperation
        {
            defer
            {
                self.initialized = true
                self.initializing = false
            }
            
            let start = Date()
            let words = self.web.getAllWords()
            let latency = abs(start.timeIntervalSinceNow)
            
            LOG.debug("Loaded \(words.count) words from the Web in \(latency)s. Saving them in memory.")
            AromaClient.sendMediumPriorityMessage(withTitle: "Web Request Complete", withBody: "Operation to load all words took \(latency)s")
            
            self.memory.removeAll()
            try? self.memory.save(words: words)
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
    
}


//MARK: Searching
public extension LexisDatabase
{
    public func searchForms(withTerm term: String) -> [LexisWord]
    {
        var results = memory.searchForWordsContaining(term: term)
        
        if results.notEmpty
        {
            return results
        }
        
        results = web.searchForWordsContaining(term: term)
        
        if results.notEmpty
        {
            startLoadingFromWeb()
        }
        
        return results
    }
    
    public func searchForms(startingWith term: String) -> [LexisWord]
    {
        var results = memory.searchForWordsStartingWith(term: term)
        
        if results.notEmpty
        {
            return results
        }
        
        results =  web.searchForWordsStartingWith(term: term)
        
        
        if results.notEmpty //This would mean the web had results but we didn't
        {
            startLoadingFromWeb()
        }
        
        return results
    }
    
    public func searchDefinitions(withTerm term: String) -> [LexisWord]
    {
        var results = memory.searchForWordsInDefinitions(term: term)
        
        if results.notEmpty
        {
            return results
        }
        
        guard let urlEncodedTerms = term.urlEncoded else { return [] }
        
        results = web.searchForWordsInDefinitions(term: urlEncodedTerms)
        
        if results.notEmpty
        {
            startLoadingFromWeb()
        }
        
        return results
    }
}
