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
    var synchronize = false
    
    private init?()
    {
        key = "\(suite).Persistence"
        guard let defaults = UserDefaults(suiteName: suite)
        else { return nil }
        
        self.defaults = defaults
    }
    
    static let instance = UserDefaultsPersistence()
    
    func save(words: [LexisWord]) throws
    {
        let data = NSKeyedArchiver.archivedData(withRootObject: words)
        defaults.set(data, forKey: key)
        
        if synchronize
        {
            defaults.synchronize()
        }
    }
    
    func getAllWords() -> [LexisWord]
    {
        guard let data = defaults.data(forKey: key)
        else
        {
            LOG.info("Failed to find LexisDatabase in UserDefaults")
            return []
        }
        
        guard let wordsArray = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSArray
        else
        {
            LOG.info("Failed to unarchive LexisDatabase from Data")
            return []
        }
        
        guard let words = wordsArray as? [LexisWord]
        else
        {
            LOG.warn("Failed to convert NSArray to [LexisWord]")
            return []
        }
        
        return words
    }

    func removeAll()
    {
        defaults.set(nil, forKey: key)
        
        if synchronize
        {
            defaults.synchronize()
        }
    }
    
}
