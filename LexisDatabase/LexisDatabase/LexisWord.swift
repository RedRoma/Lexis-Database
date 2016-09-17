//
//  LexisWord.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 8/27/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
import Sulcus


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
    
    public override var hash: Int
    {
        return hashValue
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
    

    public convenience required init?(coder encoder: NSCoder)
    {
        guard let forms = encoder.decodeObject(forKey: Keys.forms) as? [String],
                let wordTypeDictionary = encoder.decodeObject(forKey: Keys.wordType) as? NSDictionary,
                let wordType = WordType.fromJSON(dictionary: wordTypeDictionary),
                let definitions = encoder.decodeObject(forKey: Keys.definintions) as? [LexisDefinition]
        else
        {
            LOG.warn("Failed to decode LexisWord")
            return nil
        }
        
        self.init(forms: forms, wordType: wordType, definitions: definitions)
    }
    
    public func encode(with decoder: NSCoder)
    {
        decoder.encode(forms, forKey: Keys.forms)
        decoder.encode(wordType.asJSON, forKey: Keys.wordType)
        decoder.encode(definitions, forKey: Keys.definintions)
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
    
    public override var hash: Int
    {
        return hashValue
    }
}
