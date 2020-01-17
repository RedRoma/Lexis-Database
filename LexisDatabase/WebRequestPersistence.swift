//
//  WebRequestPersistence.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 10/23/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemySwift
import Archeota
import Foundation


class WebRequestPersistence: LexisPersistence
{
    private let api = "http://lexis-srv.redroma.tech:7777"
    
    private var searchWordsContainingAPI: String { return api + "/search/containing" }
    private var searchForWordsStartingWithAPI: String { return api + "/search/starting-with" }
    private var searchForWordsInDefinitionAPI: String { return api + "/search/containing-in-definition" }
    private var searchForAnyWordAPI: String { return api + "/search/any-word" }
    
    private let parser = BasicJSONSerializer.instance
    
    
    func getAllWords() -> [LexisWord]
    {
        guard let url = api.asURL else { return [] }
        
        return getWords(at: url)
    }
    
    func getAnyWord() -> LexisWord?
    {
        guard let url = searchForAnyWordAPI.asURL else { return nil }
        
        let json: String
        
        do
        {
            json = try String(contentsOf: url)
        }
        catch
        {
            LOG.error("Failed to load JSON from \(url): \(error)")
            return nil
        }
        
        guard let dictionary = parser.fromJSON(jsonString: json) as? NSDictionary else {
            LOG.error("Failed to load JSON as NSDictionary: \(json)")
            return nil
        }
        
        return LexisWord.fromJSON(json: dictionary) as? LexisWord
    }
    
    func searchForWordsContaining(term: String) -> [LexisWord]
    {
        guard let url = (searchWordsContainingAPI + "/" + term).asURL else {
            LOG.warn("Could not create URL for \(searchWordsContainingAPI)")
            return []
        }
        
        return getWords(at: url)
    }
    
    func searchForWordsStartingWith(term: String) -> [LexisWord]
    {
        guard let url = (searchForWordsStartingWithAPI + "/" + term).asURL else {
            LOG.warn("Could not create URL for \(searchForWordsStartingWithAPI)")
            return []
        }
        
       return getWords(at: url)
    }
    
    func searchForWordsInDefinitions(term: String) -> [LexisWord]
    {
        guard let urlEncodedTerm = term.urlEncoded else {
            LOG.warn("Could not URL encode \(term)")
            return []
        }
        
        guard let url = (searchForWordsInDefinitionAPI + "/" + urlEncodedTerm).asURL else {
            LOG.warn("Could not create URL for \(searchForWordsInDefinitionAPI)")
            return []
        }
     
        return getWords(at: url)
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
    
    
    private func getWords(at url: URL) -> [LexisWord]
    {
        let json: String
        
        do
        {
            json = try String(contentsOf: url)
        }
        catch
        {
            LOG.error("Failed to make request to \(url): \(error)")
            return []
        }
        
        let results = toLexisWords(json: json)
        LOG.debug("Found \(results.count) words at \(url)")
        
        return results
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
                        .compactMap(LexisWord.fromJSON)
                        .compactMap { $0 as? LexisWord }
        
        LOG.debug("Parsed [\(result.size)] words from [\(array.count)]")
        
        return result
    }
}
