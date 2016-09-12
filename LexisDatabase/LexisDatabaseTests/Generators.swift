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

struct Data
{
    static let dictionary = LexisEngine.instance.readTextFile()!
    static let words = LexisEngine.instance.getAllWords()
    static let lines = Data.dictionary.components(separatedBy: "\n").filter(String.isNotEmpty)
    
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
            case 0 :
                return WordType.Adjective
            case 1:
                return .Adjective
            case 2:
                return WordType.Conjunction
            case 3:
                return WordType.Interjection
            case 4:
                return WordType.Noun(Declension.Vocative, .Neuter)
            case 5:
                return WordType.Numeral
            case 6:
                return WordType.PersonalPronoun
            case 7:
                return WordType.Preposition(Declension.Ablative)
            default:
                return WordType.Verb(Conjugation.First, .Transitive)
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
