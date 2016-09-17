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
}

public enum Gender: String
{
    case Male
    case Female
    case Neuter
    case Unknown
    
    public var name: String { return self.rawValue }
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
}

public enum PronounType: String
{
    case Reflexive
    case Personal
    
    public var name: String { return self.rawValue }
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
    
    public var name: String
    {
        switch self
        {
            case .Adjective :
                return "Adjective"
           
            case .Adverb :
                return "Adverb"
            
            case .Conjunction :
                return "Conjunction"
          
            case .Interjection :
                return "Interjection"
            
            case let .Noun(declension, gender) :
                return "Noun - \(gender.name), \(declension.name)"
            
            case .Numeral : return "Numeral"
           
            case .PersonalPronoun :
                return "Personal Pronoun"
           
            case let .Preposition(declension) :
                return "Preposition - \(declension.name)"
            
            case .Pronoun :
                return "Pronoun"
          
            case let .Verb(conjugation, verbType):
                return "Verb - \(conjugation.name, verbType.name)"
           
            default:
                return ""
        }
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
    
    public required convenience init?(coder aDecoder: NSCoder)
    {
        guard let terms = aDecoder.decodeObject(forKey: "terms") as? [String]
        else
        {
            LOG.warn("Failed to decode terms from NSCoder")
            return nil
        }
        
        self.init(terms: terms)
    }
    
    public func encode(with aCoder: NSCoder)
    {
        aCoder.encode(terms, forKey: "terms")
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
public struct LexisWord: CustomStringConvertible, Equatable, Hashable
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
    
    public var description: String
    {
        return "\(forms) \(wordType) : [\(definitions)]"
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
    public var hashValue: Int
    {
        return forms.joined().hashValue
    }
}
