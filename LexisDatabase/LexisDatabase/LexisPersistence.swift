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

//MARK: Default Implementations
extension LexisPersistence
{
    func removeAll()
    {
        try? save(words: [])
    }
    
    func remove(word: LexisWord)
    {
        var words = getAllWords()
        
        guard let index = words.index(of: word) else { return }
        words.remove(at: index)
        try? save(words: words)
    }
    
    func searchForWords(inWordList term: String) -> [LexisWord]
    {
        guard term.notEmpty else { return [] }
        
        let words = getAllWords()
        guard words.notEmpty else { return [] }
        
        return words.filter()
        {
            let match = $0.forms.anyMatch() { form in form.contains(term) }
            return match
        }
    }
    
    func searchForWords(inDefinition term: String) -> [LexisWord]
    {
        guard term.notEmpty else { return [] }
        
        let words = getAllWords()
        guard words.notEmpty else { return [] }
        
        return words.filter()
        { word in
            
            word.definitions.anyMatch()
            { definitions in
                
                definitions.terms.anyMatch()
                { term in
                    
                    term.contains(term)
                }
            }
        }
    }
}
