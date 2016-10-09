//
//  UserDefaultsPersistence.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/17/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
import Archeota

class UserDefaultsPersistence: LexisPersistence
{
    private let suite = "tech.redroma.LexisDatabase"
    private let key: String
    private let defaults: UserDefaults
    private let serializer = BasicJSONSerializer.instance
    var synchronize = false
    
    
    /**
     Asynchronous loading
     */
    private static let parallelism = 4
    private let async: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = UserDefaultsPersistence.parallelism
        return queue
    }()
    
    private init?()
    {
        key = "\(suite).Persistence"

        self.defaults = UserDefaults(suiteName: suite) ?? UserDefaults.standard
    }
    
    static let instance = UserDefaultsPersistence()
    
    func save(words: [LexisWord]) throws
    {
        LOG.info("Saving \(words.count) words to UserDefaults")
        
        let pieces = words.split(into: UserDefaultsPersistence.parallelism)
        let serializedWords = NSMutableArray()
        
        LOG.debug("Serializing \(words.count) in \(UserDefaultsPersistence.parallelism) threads")
        
        
        var complete = 0
        var stillWorking: Bool { return complete < pieces.count }
        
        for piece in pieces {
            
            async.addOperation() {
                
                let convertedWords = piece.flatMap() { word in
                    return word.asJSON() as? NSDictionary
                }
                
                LOG.debug("Converted \(convertedWords.count) words")
                serializedWords.addObjects(from: convertedWords)
                complete += 1
            }
            
        }
        
        while stillWorking { }
        
        defaults.set(serializedWords, forKey: key)
        
        LOG.info("Saved \(serializedWords.count) words to UserDefaults")
        
        if synchronize
        {
            defaults.synchronize()
        }
    }
    
    func getAllWords() -> [LexisWord]
    {
        LOG.info("Loading Lexis Words")
        
        guard let array = defaults.object(forKey: key) as? NSArray
        else
        {
            LOG.info("Failed to find LexisDatabase in UserDefaults")
            return []
        }
        
        LOG.info("Found \(array.count) words in UserDefaults")
        
        guard let words = array as? [NSDictionary]
        else
        {
            LOG.warn("Failed to convert NSArray to [NSDictionary]")
            return []
        }
        
        let pieces = words.split(into: UserDefaultsPersistence.parallelism)
        var lexisWords = [LexisWord]()
        
        LOG.debug("Converting objects in \(pieces.count) threads")
        
        var completed = 0
        var stillWorking: Bool { return completed < pieces.count }
        
        for words in pieces {
            
            async.addOperation() {
                let convertedWords = words.flatMap() { dictionary in
                    return (LexisWord.fromJSON(json: dictionary) as? LexisWord)
                }
                
                lexisWords += convertedWords
                LOG.debug("Converted \(convertedWords.count) words")
                completed += 1
            }
            
        }
        
        while stillWorking {}
        
        LOG.info("Converted \(lexisWords.count) words from \(words.count) in JSON Array")
        return (lexisWords as? [LexisWord]) ?? []
    }

    func removeAll()
    {
        defaults.set(nil, forKey: key)
        
        LOG.info("Clearing all words from UserDefaults")
        
        if synchronize
        {
            defaults.synchronize()
        }
    }
    
}
