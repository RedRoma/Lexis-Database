//
//  SimpleUserDefaultsPersistence.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/25/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
import Archeota

class SimpleUserDefaultsPersistence: LexisPersistence
{
    private let suite = "tech.redroma.LexisDatabase"
    private let key: String
    private let defaults: UserDefaults
    private let serializer = BasicJSONSerializer.instance
    var synchronize = false
    
    private init?()
    {
        key = "\(suite).Persistence"
        
        self.defaults = UserDefaults(suiteName: suite) ?? UserDefaults.standard
    }
    
    static let instance = SimpleUserDefaultsPersistence()
    
    func save(words: [LexisWord]) throws
    {
        LOG.info("Saving \(words.count) words to UserDefaults")
        
        let convertedWords = words.flatMap() { word in
            return word.asJSON() as? NSDictionary
        }
        
        
        defaults.set(NSArray.init(array: convertedWords), forKey: key)
        
        LOG.info("Saved \(convertedWords.count) words to UserDefaults")
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
        
        let lexisWords = words.flatMap() { json in
            return (LexisWord.fromJSON(json: json)) as? LexisWord
        }
        
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
