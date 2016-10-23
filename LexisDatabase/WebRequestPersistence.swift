//
//  WebRequestPersistence.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 10/23/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Archeota
import Foundation


class WebRequestPersistence: LexisPersistence
{
    private let api = "http://lexis-srv.redroma.tech:7777"
    
    private var searchWordsContainingAPI: String { return api + "/search/containing" }
    private var searchForWordsStartingWithAPI: String { return api + "/search/starting-with" }
    private var searchForWordsInDefinitionAPI: String { return api + "/search/containing-in-definition" }
    
    private let parser = BasicJSONSerializer.instance
    
    
    internal func getAllWords() -> [LexisWord]
    {
        guard let url = api.toURL() else { return [] }
        
        let json: String
        do
        {
            try json = String(contentsOf: url)
        }
        catch
        {
            LOG.error("Failed to download JSON at \(url): \(error)")
            return []
        }
        
        
        return toLexisWords(json: json)
    }

    func save(words: [LexisWord]) throws
    {
        //Do nothing
    }
    
    func removeAll()
    {
        //Do nothing
    }
    
    func remove(word: LexisWord)
    {
        //Do nothing
    }
    
    
    private func toLexisWords(json: String) -> [LexisWord]
    {
        guard let array = parser.fromJSON(jsonString: json) as? NSArray else {
            LOG.warn("Could not parse JSON")
            return []
        }
        
        guard let dictionaryArray = array as? [NSDictionary] else {
            LOG.warn("Could not interpret Array as [NSDictionary]")
            return []
        }
        
        let result = dictionaryArray
            .flatMap(LexisWord.fromJSON)
            .flatMap() { word in return word as? LexisWord }
        
        LOG.debug("Parsed \(result.count) words from \(array.count)")
        
        return result
    }
}
