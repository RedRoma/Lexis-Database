//
//  LexisPersistence.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/3/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation


enum LexisPersistenceError: Error
{
    case InvalidArgument
}

/**
    The `LexisPersistence` protocol is reponsible for storing and querying for
    `LexisWord` objects. Besides basic CRUD operations, it also allows for searching.
 */
internal protocol LexisPersistence
{
    func save(words: [LexisWord]) throws
    
    func getAllWords() -> [LexisWord]
    
    func removeAll()
    
    func remove(word: LexisWord)
    
    func searchForWords(inWordList terms: String) -> [LexisWord]
    
    func searchForWords(inDefinition terms: String) -> [LexisWord]
}
