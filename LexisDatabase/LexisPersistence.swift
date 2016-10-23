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
    case IOError
    case ConversionError
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
    
    func searchForWordsStartingWith(term: String) -> [LexisWord]
    
    func searchForWordsContaining(term: String) -> [LexisWord]
    
    func searchForWordsInDefinitions(term: String) -> [LexisWord]
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
    
    func searchForWordsContaining(term: String) -> [LexisWord]
    {
        guard term.notEmpty else { return [] }
        
        let words = getAllWords()
        guard words.notEmpty else { return [] }
        
        return words.filter()
        {
            let match = $0.forms.anyMatch() { (form: String) in
                form.lowercased().contains(term.lowercased())
            }
            return match
        }
    }
    
   
    func searchForWordsStartingWith(term: String) -> [LexisWord]
    {
        guard term.notEmpty else { return [] }
        
        let words = getAllWords()
        guard words.notEmpty else { return [] }
        
        return words.filter()
        { word in
            
            //Keep words where it's forms begin with the search term.
            word.forms.anyMatch() { (form: String) in
                return form.lowercased().hasPrefix(term.lowercased())
            }
        }
    }
    
     func searchForWordsInDefinitions(term: String) -> [LexisWord]
    {
        guard term.notEmpty else { return [] }
        
        let words = getAllWords()
        guard words.notEmpty else { return [] }
        
        return words.filter()
        { word in
            
            word.definitions.anyMatch()
            { definitions in
                
                definitions.terms.anyMatch()
                { definition in
                    
                    definition.lowercased().contains(term.lowercased())
                }
            }
        }
    }
}
