//
//  LexisWord+WordType.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/17/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemySwift
import Archeota
import Foundation

public enum Conjugation: String, CaseIterable
{
    case First
    case Second
    case Third
    case Fourth
    case Irregular
    case Unconjugated

    public static let all = allCases
    
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
    
    private static let shortCodes: [String: Conjugation] =
    [
        "1st" : .First,
        "2nd" : .Second,
        "3rd" : .Third,
        "4th" : .Fourth
    ]
    
    static func fromShortCode(code: String) -> Conjugation
    {
        return shortCodes[code] ?? .Irregular
    }
}

public enum VerbType: String, CaseIterable
{
    case Transitive
    case Intransitive
    case Impersonal
    case Deponent
    case SemiDeponent
    case PerfectDefinite
    case Unknown

    public static let all = allCases
    
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

public enum Gender: String, CaseIterable
{
    case Male
    case Female
    case Neuter
    case Unknown

    public static let all = allCases

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

public enum Declension: String, CaseIterable
{
    case First
    case Second
    case Third
    case Fourth
    case Fifth
    case Undeclined

    public static let all = allCases
    
    public var name: String { return self.rawValue }
    
    public static func from(name: String) -> Declension?
    {
        if let declension = Declension(rawValue: name)
        {
            return declension
        }
        else
        {
            LOG.warn("Failed to decode Declension from: \(name)")
            return nil
        }
    }
    
    private static let shortCodes: [String: Declension] =
    [
        "1st" : .First,
        "2nd" : .Second,
        "3rd" : .Third,
        "4th" : .Fourth,
        "5th" : .Fifth
    ]
    
    static func fromShortCode(code: String) -> Declension
    {
        return shortCodes[code] ?? .Undeclined
    }
    
    private static let shortForms: [Declension: String] =
    [
        .First: "1st",
        .Second: "2nd",
        .Third: "3rd",
        .Fourth: "4th",
        .Fifth: "5th"
    ]
    
    public var shortForm: String
    {
        return Declension.shortForms[self] ?? "Uknwn"
    }
}

/**
    `CaseType` represents the case of a Noun or an Adjective.
 */
public enum CaseType: String, CaseIterable
{
    case Nominative
    case Genitive
    case Accusative
    case Dative
    case Ablative
    case Vocative
    case Locative
    case Unknown

    static let all = allCases
    
    public var name: String { self.rawValue }
    
    public static func from(name: String) -> CaseType?
    {
        if let caseType = CaseType(rawValue: name)
        {
            return caseType
        }
        else
        {
            LOG.warn("Failed to decode case from: \(name)")
            return nil
        }
    }
    
    static func from(shortCode: String) -> CaseType
    {
        codes[shortCode] ?? .Unknown
    }
    
    private static let codes: [String: CaseType] =
    [
        "NOM": .Nominative,
        "GEN": .Genitive,
        "ACC": .Accusative,
        "DAT": .Dative,
        "ABL": .Ablative,
        "VOC": .Vocative,
        "LOC": .Locative
    ]
    
}

public enum PronounType: String, CaseIterable
{
    case Reflexive
    case Personal

    public static let all = allCases
    
    public var name: String { self.rawValue }
    
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


public enum WordType: Equatable
{
    case Adjective
    case Adverb
    case Conjunction
    case Interjection
    case Noun(Declension, Gender)
    case Numeral
    case PersonalPronoun
    case Preposition(CaseType)
    case Pronoun
    case Verb(Conjugation, VerbType)
    
    private static let serializer = BasicJSONSerializer.instance
    
    public var description: String
    {
        self.asJSONString(serializer: WordType.serializer) ?? ""
    }
    
    public var asData: Data?
    {
        guard let jsonString = self.asJSONString(serializer: WordType.serializer) else
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
            
        case (let .Preposition(leftCaseType), let .Preposition(rightCaseType)) :
            return leftCaseType == rightCaseType
            
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

extension WordType: Hashable
{

    public func hash(into hasher: inout Hasher)
    {
        let string: String
        if case let .Verb(conjugation, verbType) = self
        {
            string = "Verb-\(conjugation)-\(verbType)"
        }
        else if case let .Noun(declension, gender) = self
        {
            string = "Noun-\(declension)-\(gender)"
        }
        else if case let .Preposition(caseType) = self
        {
            string = "Preposition-\(caseType)"
        }
        else
        {
            string = String(describing: self)
        }

        hasher.combine(string)
    }

}
