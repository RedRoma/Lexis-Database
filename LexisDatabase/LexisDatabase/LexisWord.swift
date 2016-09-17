//
//  LexisWord.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 8/27/16.
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
    
    public var asJSON: NSDictionary
    {
        let wordType = NSMutableDictionary()
        let wordTypeKey = "wordType"
        
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
                wordType["gender"] = gender.name
                wordType["declension"] = declension.name
            
            case .Numeral :
                wordType[wordTypeKey] = "Numeral"
           
            case .PersonalPronoun :
                wordType[wordTypeKey] = "PersonalPronoun"
           
            case let .Preposition(declension) :
                wordType[wordTypeKey] = "Preposition"
                wordType["declension"] = declension.name
            
            case .Pronoun :
                wordType[wordTypeKey] = "Pronoun"
          
            case let .Verb(conjugation, verbType):
                wordType[wordTypeKey] = "Verb"
                wordType["conjugation"] = conjugation.name
                wordType["verbType"] = verbType.name
        }
        
        return wordType
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

public enum Number
{
    case Singular
    case Plural
}

//===================================
//MARK: LexisDefinition
//===================================

public class LexisDefinition: NSObject, NSCoding
{
    public let terms: [String]
    
    public init(terms: [String])
    {
        self.terms = terms
    }
    
    public required convenience init?(coder decoder: NSCoder)
    {
        guard let terms = decoder.decodeObject(forKey: "terms") as? [String]
        else
        {
            LOG.warn("Failed to decode terms from NSCoder")
            return nil
        }
        
        self.init(terms: terms)
    }
    
    public func encode(with encoder: NSCoder)
    {
        encoder.encode(terms, forKey: "terms")
    }
    
    public override var description: String
    {
        return "LexisDefinition - \(terms)"
    }
}

public func ==(lhs: LexisDefinition, rhs: LexisDefinition) -> Bool
{
    return lhs.terms == rhs.terms
}

extension LexisDefinition
{
    override public var hashValue: Int
    {
        return terms.joined().hashValue
    }
}


//===================================
//MARK: LexisWord
//===================================

//This is the primary Datastructure representing a Latin word in Lexis.
public class LexisWord: NSObject, NSCoding
{
    /**
        A Word's forms represnts the different parts to a Latin vocabulary entry.
        For instance, a noun will have its nominative and genitive forms.
    */
    public let forms: [String]
    
    /**
        Determines a word's type: `[Noun, Verb, Adjective, etc]`.
    */
    public let wordType: WordType
    
    /**
        This represent a Word's separate definitions. Although each `Definition` object may have different words,
        they all essentially represent the same meaning.
     
        Whereas a different `Definition` object represents a different meaning.
    */
    public let definitions: [LexisDefinition]
    
    public init(forms: [String], wordType: WordType, definitions: [LexisDefinition])
    {
        self.forms = forms
        self.wordType = wordType
        self.definitions = definitions
    }
    

    public convenience required init?(coder aDecoder: NSCoder)
    {
        guard let forms = aDecoder.decodeObject(forKey: Keys.forms) as? [String],
                let wordType = aDecoder.decodeObject(forKey: Keys.wordType) as? WordType,
                let definitions = aDecoder.decodeObject(forKey: Keys.definintions) as? [LexisDefinition]
        else
        {
            LOG.warn("Failed to decode LexisWord")
            return nil
        }
        
        self.init(forms: forms, wordType: wordType, definitions: definitions)
    }
    
    public func encode(with aCoder: NSCoder)
    {
        aCoder.encode(forms, forKey: Keys.forms)
        aCoder.encode(wordType, forKey: Keys.wordType)
        aCoder.encode(definitions, forKey: Keys.definintions)
    }
    
    override public var description: String
    {
        return "\(forms) \(wordType) : [\(definitions)]"
    }
    
    
    class Keys
    {
        static let forms = "forms"
        static let wordType = "word_type"
        static let definintions = "definitions"
    }
    
}


public func ==(lhs: LexisWord, rhs: LexisWord) -> Bool
{
    if lhs.forms != rhs.forms
    {
        return false
    }
    
    if lhs.wordType != rhs.wordType
    {
        return false
    }
    
    if lhs.definitions != rhs.definitions
    {
        return false
    }
    
    return true
}


extension LexisWord
{
    override public var hashValue: Int
    {
        return forms.joined().hashValue
    }
}
