//
//  MemoryPersistence.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/3/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation


class MemoryPersistence: LexisPersistence
{
    private var words: [LexisWord] = []
    
    init()
    {
        
    }
    
    func save(words: [LexisWord]) throws
    {
        guard words.notEmpty else { throw LexisPersistenceError.InvalidArgument }
        
        self.words.removeAll()
        self.words +=  words
    }
    
    func getAllWords() -> [LexisWord]
    {
        return self.words
    }
    
    func removeAll()
    {
        self.words.removeAll()
    }
    
    func remove(word: LexisWord)
    {
        words = words.filter() { $0 != word }
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
