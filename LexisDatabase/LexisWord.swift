//
//  LexisWord.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 8/27/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
import Archeota


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
    
    public override var description: String
    {
        return "LexisDefinition - \(terms)"
    }
    
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
    
    public override func isEqual(_ object: Any?) -> Bool
    {
        guard let other = object as? LexisDefinition else { return false }
        
        return self == other
    }
}

public func ==(left: LexisDefinition, right: LexisDefinition) -> Bool
{
    return left.terms == right.terms
}

public func !=(left: LexisDefinition, right: LexisDefinition) -> Bool
{
    return !(left == right)
}

extension LexisDefinition
{
    override public var hashValue: Int
    {
        return terms.joined().hashValue
    }
    
    public override var hash: Int
    {
        return hashValue
    }
}


//===================================
//MARK: LexisWord
//===================================

//This is the primary Data Structure representing a Latin word in Lexis.
public class LexisWord: NSObject, NSCoding
{
    static let emptyWord = LexisWord(forms: [], wordType: .Interjection, definitions: [], supplementalInformation: .unknown)
    
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
    
    /**
        This supplemental informations provides some additional back-story on a Latin word.
        It lets the user know in what time period the word was used, how frequently,
        and in what subject area.
    */
    public let supplementalInformation: SupplementalInformation
    
    override public var description: String
    {
        return "\(forms) \(wordType) : [\(definitions)]"
    }
    
    public init(forms: [String], wordType: WordType, definitions: [LexisDefinition], supplementalInformation: SupplementalInformation)
    {
        self.forms = forms
        self.wordType = wordType
        self.definitions = definitions
        self.supplementalInformation = supplementalInformation
    }

    public convenience required init?(coder decoder: NSCoder)
    {
        guard let forms = decoder.decodeObject(forKey: Keys.forms) as? [String],
                let wordTypeDictionary = decoder.decodeObject(forKey: Keys.wordType) as? NSDictionary,
                let wordType = WordType.fromJSON(json: wordTypeDictionary) as? WordType,
                let definitions = decoder.decodeObject(forKey: Keys.definintions) as? [LexisDefinition],
                let supplementalInformation = decoder.decodeObject(forKey: Keys.supplementalInformation) as? SupplementalInformation
        else
        {
            LOG.warn("Failed to decode LexisWord")
            return nil
        }
        
        self.init(forms: forms, wordType: wordType, definitions: definitions, supplementalInformation: supplementalInformation)
    }
    
    public func encode(with encoder: NSCoder)
    {
        encoder.encode(forms, forKey: Keys.forms)
        encoder.encode(definitions, forKey: Keys.definintions)
        
        if let wordTypeObject = wordType.asJSON() as? NSDictionary
        {
            encoder.encode(wordTypeObject, forKey: Keys.wordType)
        }
        
        encoder.encode(supplementalInformation, forKey: Keys.supplementalInformation)
    }
    
    public override func isEqual(_ object: Any?) -> Bool
    {
        guard let other = object as? LexisWord else { return false }
        
        return self == other
    }
    
    fileprivate class Keys
    {
        static let forms = "forms"
        static let wordType = "word_type"
        static let definintions = "definitions"
        static let supplementalInformation = "supplemental_information"
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

public func ==(left: [LexisDefinition], right: [LexisDefinition]) -> Bool
{
    guard left.count == right.count else { return false }
    
    for (index, leftValue) in left.enumerated()
    {
        let rightValue = right[index]
        
        if rightValue != leftValue
        {
            return false
        }
    }
    
    return true
}

public func !=(left: [LexisDefinition], right: [LexisDefinition]) -> Bool
{
    return !(left == right)
}


extension LexisWord
{
    override public var hashValue: Int
    {
        return forms.joined().hashValue
    }
    
    public override var hash: Int
    {
        return hashValue
    }
}
