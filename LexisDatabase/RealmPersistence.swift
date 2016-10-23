//
//  RealmPersistence.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 10/22/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Archeota
import Foundation
import RealmSwift


class RealmPersistence: LexisPersistence
{

    static let instance = RealmPersistence()!
    
    fileprivate let realm: Realm
    
    init?()
    {
        do
        {
            try self.realm = Realm()
        }
        catch
        {
            LOG.error("Failed to load Realm: \(error)")
            return nil
        }
    }
    
    
    func save(words: [LexisWord]) throws
    {
        
    }
    
    func getAllWords() -> [LexisWord]
    {
        return []
    }
    
    func removeAll()
    {
        
    }
    
    func remove(word: LexisWord)
    {
        
    }
    
    func searchForWords(inWordList terms: String) -> [LexisWord]
    {
        return []
    }
    
    func searchForWords(inDefinition terms: String) -> [LexisWord]
    {
        return []
    }
    
}

fileprivate class RealmWord: Object
{
    
}
