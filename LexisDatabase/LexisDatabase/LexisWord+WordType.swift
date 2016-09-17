//
//  LexisWord+WordType.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/17/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
import Sulcus


public enum Conjugation: String
{
    case First
    case Second
    case Third
    case Fourth
    case Irregular
    case Unconjugated
    
    public var name: String { return self.rawValue }
    
    public static func from(name: String) -> Conjugation?
    {
        if let conjugation = Conjugation(rawValue: name)
        {
            return conjugation
        }
        else
        {
            LOG.warn("Failed to find Conjugation with name: \(name)")
            return nil
        }
    }
}

public enum VerbType: String
{
    case Transitive
    case Intransitive
    case Impersonal
    case Deponent
    case SemiDeponent
    case PerfectDefinite
    case Uknown
    
    public var name: String { return self.rawValue }
    
    public static func from(name: String) -> VerbType?
    {
        if let verbType = VerbType(rawValue: name)
        {
            return verbType
        }
        else
        {
            LOG.warn("Failed to decode Verb Type from name: \(name)")
            return nil
        }
    }
}

public enum Gender: String
{
    case Male
    case Female
    case Neuter
    case Unknown
    
    public var name: String { return self.rawValue }
    
    public static func from(name: String) -> Gender?
    {
        if let gender = Gender(rawValue: name)
        {
            return gender
        }
        else
        {
            LOG.warn("Failed to decode Gender from name: \(name)")
            return nil
        }
    }
}

public enum Declension: String
{
    case Nominative
    case Genitive
    case Accusative
    case Dative
    case Ablative
    case Vocative
    case Locative
    case Undeclined
    
    public var name: String { return self.rawValue }
    
    public static func from(name: String) -> Declension?
    {
        if let declension = Declension(rawValue: name)
        {
            return declension
        }
        else
        {
            LOG.warn("Failed to decode Declension from name: \(name)")
            return nil
        }
    }
}

public enum PronounType: String
{
    case Reflexive
    case Personal
    
    public var name: String { return self.rawValue }
    
    public static func from(name: String) -> PronounType?
    {
        if let pronounType = PronounType(rawValue: name)
        {
            return pronounType
        }
        else
        {
            LOG.warn("Failed to decode PronounType from name: \(name)")
            return nil
        }
    }
}


public enum WordType: Equatable, Hashable
{
    case Adjective
    case Adverb
    case Conjunction
    case Interjection
    case Noun(Declension, Gender)
    case Numeral
    case PersonalPronoun
    case Preposition(Declension)
    case Pronoun
    case Verb(Conjugation, VerbType)
    
    private static let wordTypeKey = "wordType"
    
    public var asJSON: NSDictionary
    {
        let wordType = NSMutableDictionary()
        let wordTypeKey = WordType.wordTypeKey
        
        switch self
        {
        case .Adjective :
            wordType[wordTypeKey] = "Adjective"
            
        case .Adverb :
            wordType[wordTypeKey] = "Adverb"
            
        case .Conjunction :
            wordType[wordTypeKey] = "Conjunction"
            
        case .Interjection :
            wordType[wordTypeKey] = "Interjection"
            
        case let .Noun(declension, gender) :
            wordType[wordTypeKey] = "Noun"
            wordType[Keys.gender] = gender.name
            wordType[Keys.declension] = declension.name
            
        case .Numeral :
            wordType[wordTypeKey] = "Numeral"
            
        case .PersonalPronoun :
            wordType[wordTypeKey] = "PersonalPronoun"
            
        case let .Preposition(declension) :
            wordType[wordTypeKey] = "Preposition"
            wordType[Keys.declension] = declension.name
            
        case .Pronoun :
            wordType[wordTypeKey] = "Pronoun"
            
        case let .Verb(conjugation, verbType):
            wordType[wordTypeKey] = "Verb"
            wordType[Keys.conjugation] = conjugation.name
            wordType[Keys.verbType] = verbType.name
        }
        
        return wordType
    }
    
    public static func fromJSON(dictionary: NSDictionary) -> WordType?
    {
        let key = WordType.wordTypeKey
        
        guard let type = dictionary[key] as? String else { return nil }
        
        if type == "Adjective"
        {
            return .Adjective
        }
        
        if type == "Adverb"
        {
            return .Adverb
        }
        
        if type == "Conjunction"
        {
            return .Conjunction
        }
        
        if type == "Noun",
            let declensionString = dictionary[Keys.declension] as? String,
            let declension = Declension.from(name: declensionString),
            let genderString = dictionary[Keys.gender] as? String,
            let gender = Gender.from(name: genderString)
        {
            return .Noun(declension, gender)
        }
        
        if type == "Numeral"
        {
            return .Numeral
        }
        
        if type == "PersonalPronoun"
        {
            return .PersonalPronoun
        }
        
        if type == "Preposition",
            let declensionString = dictionary[Keys.declension] as? String,
            let declension = Declension.from(name: declensionString)
        {
            return .Preposition(declension)
        }
        
        if type == "Pronoun"
        {
            return .Pronoun
        }
        
        if type == "Verb",
            let conjugationString = dictionary[Keys.conjugation] as? String,
            let conjugation = Conjugation.from(name: conjugationString),
            let verbTypeString = dictionary[Keys.verbType] as? String,
            let verbType = VerbType.from(name: verbTypeString)
        {
            return .Verb(conjugation, verbType)
        }
        
        return nil
    }
    
    public var description: String
    {
        guard let data = try? JSONSerialization.data(withJSONObject: asJSON, options: [])
            else
        {
            LOG.warn("Failed to serialize as JSON: \(asJSON)")
            return ""
        }
        
        let jsonString = String.init(data: data, encoding: .utf8)
        
        return jsonString ?? ""
    }
    
    public var asData: Data
    {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self.asJSON, options: [])
        {
            return jsonData
        }
        
        return Data()
    }
    
    public static func from(data: Data) -> WordType?
    {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
            let dictionary = jsonObject as? NSDictionary
            else
        {
            LOG.warn("Failed to deserialize object from JSON")
            return nil
        }
        
        return WordType.fromJSON(dictionary: dictionary)
    }
    
    private class Keys
    {
        static let declension = "declension"
        static let gender = "gender"
        static let conjugation = "conjugation"
        static let verbType = "verbType"
    }
}

public func ==(lhs: WordType, rhs: WordType) -> Bool
{
    
    switch (lhs, rhs)
    {
    case (let .Verb(leftConjugation, leftVerbType), let .Verb(rightConjugation, rightVerbType)) :
        return leftConjugation == rightConjugation && leftVerbType == rightVerbType
        
    case (let .Noun(leftDeclension, leftGender), let .Noun(rightDeclension, rightGender)) :
        return leftDeclension == rightDeclension && leftGender == rightGender
        
    case (let .Preposition(leftDeclension), let .Preposition(rightDeclension)) :
        return leftDeclension == rightDeclension
        
    case (.Adjective, .Adjective) : return true
    case (.Adverb, .Adverb) : return true
    case (.Conjunction, .Conjunction) : return true
    case (.Interjection, .Interjection) : return true
    case (.Numeral, .Numeral) : return true
    case (.PersonalPronoun, .PersonalPronoun) : return true
    case (.Pronoun, .Pronoun) : return true
        
    default:
        return false
    }
    
}

extension WordType
{
    public var hashValue: Int
    {
        if case let .Verb(conjugation, verbType) = self
        {
            return ("\(conjugation)-\(verbType)").hashValue
        }
        
        if case let .Noun(declension, gender) = self
        {
            return "Noun-\(declension)-\(gender)".hashValue
        }
        
        if case let .Preposition(declension) = self
        {
            return "Preposition-\(declension)".hashValue
        }
        
        let string = String(describing: self)
        return string.hashValue
    }
}
