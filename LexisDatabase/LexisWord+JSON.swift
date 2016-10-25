//
//  LexisWord+JSON.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/19/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
import Archeota

fileprivate class Keys
{
    static let forms = "forms"
    static let wordType = "word_type"
    static let definitions = "definitions"
    static let supplementalInformation = "supplemental_information"
}


//MARK: LexisWord
extension LexisWord: JSONConvertible
{
    func asJSON() -> Any?
    {
        var json = [String: Any]()
        
        json[Keys.forms] = (self.forms as NSArray)
        json[Keys.wordType] = self.wordType.asJSON()
        json[Keys.supplementalInformation] = self.supplementalInformation.asJSON()
        
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
        
        guard let wordType = WordType.fromJSON(json: wordTypeJSON) as? WordType
        else
        {
            LOG.error("Failed to interpret Word Type from JSON: \(wordTypeJSON)")
            return nil
        }
        
        guard let definitionsJSON = object[Keys.definitions] as? NSArray
        else
        {
            LOG.error("Missing definitions in JSONL \(object)")
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
        
        guard let supplementalInformationObject = object[Keys.supplementalInformation] as? NSDictionary
        else
        {
            LOG.error("Missing Supplemental Information from JSON: \(json))")
            return nil
        }
        
        guard let supplementalInformation = SupplementalInformation.fromJSON(json: supplementalInformationObject) as? SupplementalInformation
        else
        {
            LOG.error("Failed to interpret JSOn object as SupplementalInformation: \(supplementalInformationObject)")
            return nil
        }
        
        
        return LexisWord(forms: forms, wordType: wordType, definitions: definitions, supplementalInformation: supplementalInformation)
    }
}

//MARK: Public JSON export
public extension LexisWord
{
    public var json: NSDictionary
    {
        return (self.asJSON() as? NSDictionary) ?? NSDictionary()
    }
    
    internal convenience init(other: LexisWord)
    {
        self.init(forms: other.forms, wordType: other.wordType, definitions: other.definitions, supplementalInformation: other.supplementalInformation)
    }
    
    public convenience init?(json: NSDictionary)
    {
        if let word = LexisWord.fromJSON(json: json) as? LexisWord
        {
            self.init(other: word)
        }
        else
        {
            return nil
        }
    }
}
