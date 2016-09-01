//
//  LexisEngine.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 8/27/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
import Sulcus

/**
     The Lexis Engine is reponsible for reading through the Dictionary text file
     And extracting meaningful information from it, for the purpose of
     Storing representing in a LexisWord data structure
 */
internal class LexisEngine
{
    
    public static let instance = LexisEngine()
    
    private var isInitialized = false
    
    private init()
    {
        
    }
    
    func initialize()
    {
        guard !isInitialized else { return }
    
        let allWords = readAllWords()
        
        saveInTheDatabase(words: allWords)
    }
    
    private func readAllWords() -> [LexisWord]
    {
        
        //Read the text file
        //Iterate line by line
        //Parse out the words list
        //Parse out the word modifiers
        //Parse out the dictionary code
        //Parse out the dictionary Terms
        //For each line, assemnble a LexisWord object from the parsed out words
        guard let file = readTextFile()
        else
        {
            LOG.error("Could not load Latin Dictionary text file")
            return []
        }
        
        var words: [LexisWord] = []
        
        let saveToArray: (LexisWord) -> () = { word in
            words.append(word)
        }
        
        file.processEachLine(mapper: self.mapLineToWord, processor: saveToArray)
        
        return words
    }
    
    private func saveInTheDatabase(words: [LexisWord])
    {
        //Save this into Realm directly, or use a protocol to abstract that part away
    }
    
}


//MARK: Text Processing
extension LexisEngine
{
    
    func readTextFile() -> String?
    {
        
        let bundle = Bundle(for: LexisEngine.self)
        
        let resourceName = "LatinDictionary"
        
        guard let url = bundle.url(forResource: resourceName, withExtension: "txt")
        else
        {
            LOG.error("Failed to load resource \(resourceName)")
            return nil
        }
        
        do
        {
            return try String(contentsOf: url)
        }
        catch
        {
            LOG.error("Failed to load String from URL: \(url) : \(error)")
        }
        
        return nil
    }
    
    
    func mapLineToWord(line: String) -> LexisWord?
    {
        guard line.notEmpty else { return nil }
        
        let forms = extractWords(from: line)
        guard let wordType = extractWordType(from: line)
        else
        {
            LOG.warn("Could not extact word type from: \(line)")
            return nil
        }
        
        return LexisWord(forms: forms, wordType: wordType)
        
    }
    
    func extractWords(from line: String) -> [String]
    {
        guard line.notEmpty else { return [] }
        
        let matches = line =~ Regex.wordList
        
        guard let match = matches.first
        else
        {
            LOG.warn("No Words found in Line: \(line)")
            return []
        }
        
       return match.components(separatedBy: ", ")

    }
    
    func extractWordType(from line: String) -> WordType?
    {
        guard line.notEmpty else { return nil }
        
        let wordModifiers = line =~ Regex.wordModifiers
        func warnIfMoreThanOneModifier()
        {
            if wordModifiers.count > 1
            {
                LOG.warn("Adjective has more than one modifier: \(line)")
            }
        }

        
        //Verbs
        if isVerb(wordModifiers: wordModifiers)
        {
            let wordType = getVerbType(fromLine: line, withModifiers: wordModifiers)
            warnIfVerbIsUnconjugated(wordType, line: line)
            return wordType
        }
        
        
        //Adjectives
        if isAdjective(wordModifiers: wordModifiers)
        {
            warnIfMoreThanOneModifier()
            return WordType.Adjective
        }
        
        //Adverbs
        if isAdverb(wordModifiers: wordModifiers)
        {
            warnIfMoreThanOneModifier()
            return WordType.Adverb
        }
        
        //Prepositions
        if isPreposition(wordModifiers: wordModifiers),
           let declensionText = wordModifiers.second
        {
            let declension = getDeclensionForNoun(from: declensionText)
            return WordType.Preposition(declension)
        }
        
        //Interjections
        if isInterjection(wordModifiers: wordModifiers)
        {
            return WordType.Interjection
        }
        
        //Conjugations
        if isConjugation(wordModifiers: wordModifiers)
        {
            return WordType.Conjugation
        }
        
        //Lastly, nouns
        if isNoun(wordModifiers: wordModifiers)
        {
            let nounType = getNounType(fromLine: line, withModifiers: wordModifiers)
            warnIfNounIsUndeclined(nounType, line: line)
            return nounType
        }
        
        print("Could not extract word: \(line)")
        
        return nil
    }
    
    func warnIfNounIsUndeclined(_ wordType: WordType, line: String)
    {
        if case let WordType.Noun(declension, gender) = wordType
        {
            if declension == .Undeclined
            {
                LOG.warn("Noun is Undeclined: \(line)")
            }
        }
    }
    
    func warnIfVerbIsUnconjugated(_ wordType: WordType, line: String)
    {
        if case let WordType.Verb(conjugation, verbType) = wordType
        {
            if conjugation == .Unconjugated
            {
                LOG.warn("Verb is Unconjugated: \(line)")
            }
            
            if conjugation == .Irregular
            {
                LOG.info("Verb is Irregular: \(line)")
            }
        }
    }
    
    
}


//MARK: Word Type Detection
extension LexisEngine
{
    
    func getVerbType(fromLine line: String, withModifiers modifiers: [String]) -> WordType
    {
        let conjugationResults = line =~ Regex.declension
        let conjugationText = conjugationResults.first
        let conjugation = getConjugation(from: conjugationText)
        
        if modifiers.contains(Keywords.intransitive)
        {
            return WordType.Verb(conjugation, .Intransitive)
        }
        else if modifiers.contains(Keywords.transitive)
        {
            return WordType.Verb(conjugation, .Transitive)
        }
        else if modifiers.contains(Keywords.deponent)
        {
            return WordType.Verb(conjugation, .Deponent)
        }
        else if modifiers.contains(Keywords.impersonal)
        {
            return WordType.Verb(conjugation, .Impersonal)
        }
        else
        {
            LOG.warn("Uknown Verb Type: \(line)")
            return WordType.Verb(conjugation, .Uknown)
        }
    }
    
    func getNounType(fromLine line: String, withModifiers modifiers: [String]) -> WordType
    {
        let declensionResults = line =~ Regex.declension
        let declensionText = declensionResults.first
        let declension = getDeclensionForNoun(from: declensionText)
        
        if modifiers.contains(Keywords.masculine)
        {
            return WordType.Noun(declension, .Male)
        }
        else if modifiers.contains(Keywords.feminine)
        {
            return WordType.Noun(declension, .Female)
        }
        else if modifiers.contains(Keywords.neuter)
        {
            return WordType.Noun(declension, .Neuter)
        }
        else
        {
            LOG.warn("Noun is missing gender: \(line)")
            return WordType.Noun(declension, .Unknown)
        }
    }
    
    func getConjugation(from text: String?) -> Conjugation
    {
        
        guard let text = text else { return Conjugation.Unconjugated }
        
        switch text
        {
            case "1st" : return Conjugation.First
            case "2nd" : return Conjugation.Second
            case "3rd" : return Conjugation.Third
            case "4th" : return Conjugation.Fourth
            default:     return Conjugation.Irregular
        }
    }
    
    func getDeclensionForNoun(from declensionText: String?) -> Declension
    {
        guard let declensionText = declensionText else { return .Undeclined }
        
        switch declensionText
        {
            case "1st" : return .Nominative
            case "2nd" : return .Genitive
            case "3rd" : return .Accusative
            case "4th" : return .Dative
            case "5th" : return .Ablative
            case "6th" : return .Vocative
            case "7th" : return .Locative
            default :    return .Undeclined
        }
    }
    
    func getDeclensionForPreposition(from preposition: String) -> Declension
    {
        switch preposition
        {
            case "ACC" : return .Accusative
            case "GEN" : return .Genitive
            case "ABL" : return .Ablative
            default :    return .Undeclined
        }
    }

    
    
    func isVerb(wordModifiers: [String]) -> Bool
    {
        return wordModifiers.contains(Keywords.verb)
    }
    
    func isNoun(wordModifiers: [String]) -> Bool
    {
        return wordModifiers.contains(Keywords.noun)
    }
    
    func isPreposition(wordModifiers: [String]) -> Bool
    {
        return wordModifiers.contains(Keywords.preposition)
    }
    
    func isAdjective(wordModifiers: [String]) -> Bool
    {
        return wordModifiers.contains(Keywords.adjective)
    }
    
    func isAdverb(wordModifiers: [String]) -> Bool
    {
        return wordModifiers.contains(Keywords.adverb)
    }
    
    func isConjugation(wordModifiers: [String]) -> Bool
    {
        return wordModifiers.contains(Keywords.conjugation)
    }
    
    func isInterjection(wordModifiers: [String]) -> Bool
    {
        return wordModifiers.contains(Keywords.interjection)
    }
}


//MARK: Dictionary keywords
private class Keywords
{
    static let verb = "V"
    static let transitive = "TRANS"
    static let intransitive = "INTRANS"
    static let deponent = "DEP"
    static let impersonal = "IMPERS"
    
    static let adverb = "ADV"
    
    static let noun = "N"
    static let adjective = "ADJ"
    static let feminine = "F"
    static let masculine = "M"
    static let neuter = "N"
    
    static let preposition = "PREP"
    static let accusative = "ACC"
    
    static let interjection = "INTERJ"
    static let conjugation = "CONJ"
}
