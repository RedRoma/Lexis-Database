//
//  WordType+JSON.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/19/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
import Archeota

fileprivate class Keys
{
    static let caseType = "caseType"
    static let declension = "declension"
    static let gender = "gender"
    static let conjugation = "conjugation"
    static let verbType = "verbType"
    
    static let wordTypeKey = "wordType"
}

extension WordType: JSONConvertible
{
    
    public func asJSON() -> Any?
    {
        var object = [String: Any]()
        let wordTypeKey = Keys.wordTypeKey
        
        switch self
        {
            case .Adjective :
                object[wordTypeKey] = "Adjective"
                
            case .Adverb :
                object[wordTypeKey] = "Adverb"
                
            case .Conjunction :
                object[wordTypeKey] = "Conjunction"
                
            case .Interjection :
                object[wordTypeKey] = "Interjection"
                
            case let .Noun(declension, gender) :
                object[wordTypeKey] = "Noun"
                object[Keys.gender] = gender.name
                object[Keys.declension] = declension.name
                
            case .Numeral :
                object[wordTypeKey] = "Numeral"
                
            case .PersonalPronoun :
                object[wordTypeKey] = "PersonalPronoun"
                
            case let .Preposition(caseType) :
                object[wordTypeKey] = "Preposition"
                object[Keys.caseType] = caseType.name
                
            case .Pronoun :
                object[wordTypeKey] = "Pronoun"
                
            case let .Verb(conjugation, verbType):
                object[wordTypeKey] = "Verb"
                object[Keys.conjugation] = conjugation.name
                object[Keys.verbType] = verbType.name
        }
        
        return object
    }
    
    static func fromJSON(json: Any) -> JSONConvertible?
    {
        guard let object = json as? [String: Any]
        else
        {
            LOG.error("Expected Dictionary, but instead: \(json)")
            return nil
        }
        
        let key = Keys.wordTypeKey
        
        guard let type = object[key] as? String else { return nil }
        
        if type == "Adjective"
        {
            return WordType.Adjective
        }
        
        if type == "Adverb"
        {
            return WordType.Adverb
        }
        
        if type == "Conjunction"
        {
            return WordType.Conjunction
        }
        
        if type == "Interjection"
        {
            return WordType.Interjection
        }
        
        if type == "Noun",
            let declensionString = object[Keys.declension] as? String,
            let declension = Declension.from(name: declensionString),
            let genderString = object[Keys.gender] as? String,
            let gender = Gender.from(name: genderString)
        {
            return WordType.Noun(declension, gender)
        }
        
        if type == "Numeral"
        {
            return WordType.Numeral
        }
        
        if type == "PersonalPronoun"
        {
            return WordType.PersonalPronoun
        }
        
        if type == "Preposition",
            let caseTypeString = object[Keys.caseType] as? String,
            let caseType = CaseType.from(name: caseTypeString)
        {
            return WordType.Preposition(caseType)
        }
        
        if type == "Pronoun"
        {
            return WordType.Pronoun
        }
        
        if type == "Verb",
            let conjugationString = object[Keys.conjugation] as? String,
            let conjugation = Conjugation.from(name: conjugationString),
            let verbTypeString = object[Keys.verbType] as? String,
            let verbType = VerbType.from(name: verbTypeString)
        {
            return WordType.Verb(conjugation, verbType)
        }
        
        return nil
    }
}
