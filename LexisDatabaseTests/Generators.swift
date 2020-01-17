//
//  Generators.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/2/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyGenerator
import Foundation
@testable import LexisDatabase

struct Generators
{
    static let dictionary = LexisEngine.shared.readTextFile()!
    static let words = LexisEngine.shared.getAllWords()
    static let lines = Generators.dictionary.components(separatedBy: "\n").filter(String.isNotEmpty)
    
    static var randomWord: LexisWord
    {
        words.anyElement!
    }
    
    static var randomLine: String
    {
        let randomLineNumber = AlchemyGenerator.integer(from: 1, to: 30_000)
        return lines[randomLineNumber]
    }
    
    static var randomWordType: WordType
    {
        let index = AlchemyGenerator.integer(from: 0, to: 10)

        switch index
        {
            case 0 :  return .Adjective
            case 1 :  return .Adverb
            case 2 :  return .Conjunction
            case 3 :  return .Interjection
            case 4 :  return .Noun(randomDeclension, randomGender)
            case 5 :  return .Numeral
            case 6 :  return .PersonalPronoun
            case 7 :  return .Preposition(randomCaseType)
            default : return .Verb(randomConjugation, randomVerbType)
        }
    }
    
    static var randomCaseType: CaseType
    {
        let index = AlchemyGenerator.integer(from: 0, to: 7)
        
        switch index
        {
            case 0 :  return .Nominative
            case 1 :  return .Genitive
            case 2 :  return .Accusative
            case 3 :  return .Dative
            case 4 :  return .Ablative
            case 5 :  return .Locative
            case 6 :  return .Vocative
            default : return .Nominative
        }
    }
    
    static var randomConjugation: Conjugation
    {
        let index = AlchemyGenerator.integer(from: 0, to: 7)
        
        switch index
        {
            case 0 :  return .First
            case 1 :  return .Second
            case 2 :  return .Third
            case 3 :  return .Fourth
            default : return .Irregular
        }
    }
    
    static var randomDeclension: Declension
    {
        let index = AlchemyGenerator.integer(from: 0, to: 7)
        
        switch index
        {
            case 0 :  return .First
            case 1 :  return .Second
            case 2 :  return .Third
            case 3 :  return .Fourth
            case 4 :  return .Fifth
            default : return .Undeclined
        }
    }
    
    static var randomGender: Gender
    {
        let index = AlchemyGenerator.integer(from: 0, to: 3)
        
        switch index
        {
            case 0 :  return .Male
            case 1 :  return .Female
            case 2 :  return .Neuter
            default : return .Female
        }
    }
    
    static var randomAge: Age
    {
        Age.ages.anyElement!
    }
    
    static var randomSubject: SubjectArea
    {
        SubjectArea.areas.anyElement!
    }
    
    static var randomGeography: GeographicalArea
    {
        GeographicalArea.geophraphies.anyElement!
    }
    
    static var randomFrequency: Frequency
    {
        Frequency.frequencies.anyElement!
    }
    
    static var randomSource: Source
    {
        Source.sources.anyElement!
    }
    
    static var randomSupplementalInformation: SupplementalInformation
    {
        SupplementalInformation(age: randomAge, subjectArea: randomSubject, geographicalArea: randomGeography, frequency: randomFrequency, source: randomSource)
    }
    
    static var randomVerbType: VerbType
    {
        let index = AlchemyGenerator.integer(from: 0, to: 10)

        switch index
        {
            case 0 :  return .Deponent
            case 1 :  return .Impersonal
            case 2 :  return .Intransitive
            case 3 :  return .PerfectDefinite
            case 4 :  return .SemiDeponent
            case 5 :  return .Transitive
            default : return .Unknown
        }
    }
}

func allIntegers(from: Int, to: Int) -> [Int]
{
    var array = [Int]()
    
    for i in (from...to)
    {
        array.append(i)
    }
    
    return array
}
