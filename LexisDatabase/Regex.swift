//
//  Regex.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 8/30/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
import Archeota

struct Regex
{
    /**
     Matches the actual Latin Words.
     For example, Veritate.
     */
    static let wordList = "(?<=#)(.*?)(?=\\s{2,})"
    
    /**
     Searches for the word's modifiers that tell what the function
     of the word is. For example, Verb, Noun, etc.
     It also finds secondary modifiers, like gender, and verb transitivity.
     */
    static let wordModifiers = "(?<= )(INTRANS|TRANS|ADJ|ADV|CONJ|PREP|ACC|INTERJ|V|N|F|M|PRON|PERS|REFLEX|NOM|ACC|ABL|DAT|GEN|VOC|LOC|DEP|SEMIDEP|PERFDEF|NUM)(?= )"
    
    /**
     Matches the dictionary code. This code includes information on the word's origin and use.
     */
    static let dictionaryCode = "(?<=\\[)([A-Z]{5})(?=\\])"
    
    /**
     Matches the English portion of the word. This phrase includes the entire string term,
     which may include multiple definitions and terms.
     */
    static let definitionTerms = "(?<=:: )(.*)"
    
    /**
     Matches the Verb or Noun's declension. It includes the entire english phrase,
     for example, "1st", "2nd", etc.
     
     This also matches for a Verb's Conjugation.
     */
    static let declension = "(?<=[NV] \\()([1-4][a-z]{2})(?=\\))"
}


//MARK: Regex syntax
infix operator =~

func =~ (string: String, pattern: String) -> [String]
{
    let regex: NSRegularExpression
    
    do
    {
        regex = try NSRegularExpression(pattern: pattern, options: [])
    }
    catch
    {
        LOG.error("Pattern is not valid regex: \(error)")
        return []
    }
    
    let nsString = string as NSString
    let results = regex.matches(in: string, options: [], range: NSMakeRange(0, nsString.length))
    
    return results.map() { return nsString.substring(with: $0.range) }
}
