//
//  LexisWord+JSON.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/19/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
import Sulcus

fileprivate class Keys
{
    static let forms = "forms"
    static let wordType = "word_type"
    static let definitions = "definitions"
}


//MARK: LexisWord
extension LexisWord: JSONConvertible
{
    func asJSON() -> Any?
    {
        var json = [String: Any]()
        
        json[Keys.forms] = (self.forms as NSArray)
        json[Keys.wordType] = self.wordType.asJSON
        
        
        let definitionsJSON = definitions.flatMap() { (definition: LexisDefinition) -> (Any?) in
            return definition.asJSON()
        }
        
        json[Keys.definitions] = definitionsJSON
        
        return json
    }
    
    static func fromJSON(json: Any) -> JSONConvertible?
    {
        guard let object = json as? [String: Any]
        else
        {
            LOG.error("Expecting Dictionary, instead: \(json)")
            return nil
        }
        
        guard let forms = object[Keys.forms] as? [String]
        else
        {
            LOG.error("Missing word forms in JSON")
            return nil
        }
        
        guard let wordTypeJSON = object[Keys.wordType] as? NSDictionary
        else
        {
            LOG.error("Missing word type in JSON: \(object)")
            return nil
        }
        
        guard let wordType = WordType.fromJSON(dictionary: wordTypeJSON)
        else
        {
            LOG.error("Failed to interpret Word Type from JSON: \(wordTypeJSON)")
            return nil
        }
        
        guard let definitionsJSON = object[Keys.definitions] as? NSArray
        else
        {
            LOG.error("Missing defiinitions in JSONL \(object)")
            return nil
        }
        
        guard let definitionObjects = definitionsJSON as? [NSDictionary]
        else
        {
            LOG.error("Expecting definitions JSON to be an Array of Dictionaries, instead: \(definitionsJSON)")
            return nil
        }
        
        let definitions = definitionObjects.flatMap() { dictionary in
            return LexisDefinition.fromJSON(json: dictionary) as? LexisDefinition
        }
        
        return LexisWord(forms: forms, wordType: wordType, definitions: definitions)
    }
}
