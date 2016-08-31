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
        let conjugationOrDeclension = line =~ Regex.declension
        
        let verbKeyword = "V"
        let transitiveKeyword = "TRANS"
        let intransitiveKeyword = "INTRANS"
        let deponentKeyword = "DEP"
        let impersonalKeyword = "IMPERS"
        
        let nounKeyword = "N"
        let adjectiveKeyword = "ADJ"
        let feminineKeyword = "F"
        let masculineKeyword = "M"
        let neuterKeyword = "N"
        
        let prepositionKeyword = "PREP"
        let accusativeKeyword = "ACC"
        
        let interjectionKeyword = "INTERJ"
        
        
        
        //Verbs
        if wordModifiers.contains(verbKeyword),
           let conjugationText = conjugationOrDeclension.first,
           let conjugation = getConjugation(from: conjugationText)
        {
            
            if wordModifiers.contains(intransitiveKeyword)
            {
                return WordType.Verb(conjugation, .Intransitive)
            }
            else if wordModifiers.contains(transitiveKeyword)
            {
                return WordType.Verb(conjugation, .Transitive)
            }
            else if wordModifiers.contains(deponentKeyword)
            {
                return WordType.Verb(conjugation, .Deponent)
            }
            else if wordModifiers.contains(impersonalKeyword)
            {
                return WordType.Verb(conjugation, .Impersonal)
            }
            else
            {
                LOG.warn("Undetected Verb Type: \(wordModifiers)")
            }
        }
        
        
        
        //Adjectives
        if wordModifiers.contains(adjectiveKeyword)
        {
            if wordModifiers.count > 1
            {
                LOG.warn("Adjective has more than one modifier: \(line)")
            }
            
            return WordType.Adjective
        }
        
        //Prepositions
        if wordModifiers.contains(prepositionKeyword),
           let declensionText = wordModifiers.second,
           let declension = getDeclension(fromPreposition: declensionText)
        {
            return WordType.Preposition(declension)
        }
        
        //Interjections
        if wordModifiers.contains(interjectionKeyword)
        {
            return WordType.Interjection
        }
        
        //Lastly, nouns
        if wordModifiers.contains(nounKeyword),
           let declensionText = conjugationOrDeclension.first,
           let declension = getDeclension(from: declensionText)
        {
            
            if wordModifiers.contains(masculineKeyword)
            {
                return WordType.Noun(declension, .Male)
            }
            else if wordModifiers.contains(feminineKeyword)
            {
                return WordType.Noun(declension, .Female)
            }
            else if wordModifiers.contains(neuterKeyword)
            {
                return WordType.Noun(declension, .Neuter)
            }
            else
            {
                LOG.warn("Noun is missing gender: \(line)")
            }
        }
        
        
        return nil
    }
    
    func getConjugation(from text: String) -> Conjugation?
    {
        switch text
        {
            case "1st" : return Conjugation.First
            case "2nd" : return Conjugation.Second
            case "3rd" : return Conjugation.Third
            case "4th" : return Conjugation.Fourth
            default:     return nil
        }
    }
    
    func getDeclension(from text: String) -> Declension?
    {
        switch text
        {
            case "1st" : return .Nominative
            case "2nd" : return .Genitive
            case "3rd" : return .Accusative
            case "4th" : return .Dative
            case "5th" : return .Ablative
            case "6th" : return .Vocative
            case "7th" : return .Locative
            default :    return nil
        }
    }
    
    func getDeclension(fromPreposition text: String) -> Declension?
    {
        switch text
        {
            case "ACC" : return .Accusative
            case "GEN" : return .Genitive
            case "ABL" : return .Ablative
            default : return nil
        }
    }

}
