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
        let jsonArray = words.flatMap() { word in
            return word.asJSON()
        }
        
        LOG.info("Persisting \(jsonArray.count) words in UserDefaults")
        
        guard let json = serializer.toJSON(object: jsonArray)
        else
        {
            LOG.error("Failed to serialize JSON Array to a JSON String")
            return
        }
        
        defaults.set(json, forKey: key)
        
        if synchronize
        {
            defaults.synchronize()
        }
    }
    
    func getAllWords() -> [LexisWord]
    {
        guard let json = defaults.object(forKey: key) as? String
        else
        {
            LOG.info("Failed to find LexisDatabase in UserDefaults")
            return []
        }
        
        guard let jsonArray = serializer.fromJSON(jsonString: json) as? NSArray
        else
        {
            LOG.error("Failed to deserialize JSON as an Array")
            return []
        }
        
        
        guard let words = jsonArray as? [NSDictionary]
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
