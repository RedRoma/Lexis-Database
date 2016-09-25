//
//  UserDefaultsPersistence.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/17/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
import Sulcus

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
    private let async: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 4
        return queue
    }()
    
    private init?()
    {
        key = "\(suite).Persistence"

        self.defaults = UserDefaults.standard
    }
    
    static let instance = UserDefaultsPersistence()
    
    func save(words: [LexisWord]) throws
    {
        LOG.info("Saving \(words.count) words to UserDefaults")
        
        let objects = words.flatMap() { word in
            return word.asJSON() as? NSDictionary
        }
        
        defaults.set(NSArray.init(array: objects), forKey: key)
        
        LOG.info("Saved \(objects.count) words to UserDefaults")
        
        if synchronize
        {
            defaults.synchronize()
        }
    }
    
    func getAllWords() -> [LexisWord]
    {
        guard let array = defaults.object(forKey: key) as? NSArray
        else
        {
            LOG.info("Failed to find LexisDatabase in UserDefaults")
            return []
        }
        
        guard let words = array as? [NSDictionary]
        else
        {
            LOG.warn("Failed to convert NSArray to [NSDictionary]")
            return []
        }
        
        LOG.info("Loaded \(words.count) words from UserDefaults")
        
        let pieces = words.split(into: 6)
        var lexisWords = [LexisWord]()
        
        for words in pieces {
            
            async.addOperation() {
                let convertedWords = words.flatMap() { dictionary in
                    return (LexisWord.fromJSON(json: dictionary) as? LexisWord)
                }
                lexisWords += convertedWords
            }
            
        }
        
        async.waitUntilAllOperationsAreFinished()
        
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
