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
    
    private static let serializer = BasicJSONSerializer.instance
    
    public var description: String
    {
        return self.asJSONString(serializer: WordType.serializer) ?? ""
    }
    
    public var asData: Data?
    {
        guard let jsonString = self.asJSONString(serializer: WordType.serializer)
        else
        {
            return nil
        }
        
        return jsonString.data(using: .utf8)
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
        
        return WordType.fromJSON(json: dictionary) as? WordType
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