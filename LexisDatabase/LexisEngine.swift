 //
//  LexisEngine.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 8/27/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
import Archeota

/**
     The Lexis Engine is reponsible for reading through the Dictionary text file
     And extracting `LexisWord` representations from them.
  
     > It is not responsible for persistence of those words.
 */
internal class LexisEngine
{
    
    public static let instance = LexisEngine()
    
    private var dictionary: String? = nil
    
    private init()
    {
        initialize()
    }
    
    func getAllWords() -> [LexisWord]
    {
        guard let dictionary = self.dictionary
        else
        {
            LOG.error("Could not read the Latin Dictionary file")
            return []
        }
        
        return readAllWords(fromDictionary: dictionary)
    }
    
    private func initialize()
    {
        guard let dictionaryFile = self.readTextFile()
        else
        {
            LOG.error("Could not load Latin Dictionary text file")
            return
        }
    
        dictionary = dictionaryFile
    }
    
    func readAllWords(fromDictionary file: String) -> [LexisWord]
    {
        
        //Read the text file
        //Iterate line by line
        //Parse out the words list
        //Parse out the word modifiers
        //Parse out the dictionary code
        //Parse out the dictionary Terms
        //For each line, assemnble a LexisWord object from the parsed out words
        
        var words: [LexisWord] = []
        
        let collectInArray: (LexisWord) -> () = { word in
            words.append(word)
        }
        
        file.processEachLine(mapper: self.mapLineToWord, processor: collectInArray)
        
        LOG.debug("Finished compiling a list of \(words.count) words")
        return words
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
    
    
    func mapLineToWord(line: String, at lineNumber: Int) -> LexisWord?
    {
        guard line.notEmpty else { return nil }
        
        let forms = extractWords(from: line)
        guard let wordType = extractWordType(from: line, at: lineNumber)
        else
        {
            LOG.info("Could not extact word type at line #\(lineNumber)")
            return nil
        }
        
        let definitions = extractDefinitions(from: line)
        
        guard let supplementalInformation = getSupplementalInformation(fromLine: line)
        else
        {
            LOG.warn("Failed to load Supplemental information for: \(line)")
            return nil
        }
        
        return LexisWord(forms: forms, wordType: wordType, definitions: definitions, supplementalInformation: supplementalInformation)
        
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
 }
 
 //MARK: Extract Word Definitions
 extension LexisEngine
 {
    func extractDefinitions(from line: String) -> [LexisDefinition]
    {
        let matches = line =~ Regex.definitionTerms
        
        guard matches.notEmpty
        else
        {
            LOG.warn("No word definitions found for: \(line)")
            return []
        }
        
        guard let definitionString = matches.first, matches.count == 1
        else
        {
            LOG.warn("Definition extraction expected 1 result but got \(matches.count) instead, for line: \(line)")
            return []
        }
        
        let distinctDefinitions = splitDefinitionsByMeaning(definitions: definitionString)
                                     .filter({$0.notEmpty})
        
        guard distinctDefinitions.notEmpty
        else
        {
            LOG.warn("Did not find any definitions for: \(line)")
            return []
        }
        
        return distinctDefinitions.map()
            { def in
                
                if def.doesNotContain(anyOf: ["(", ")"])
                {
                    let individualWords = def.components(separatedBy: ", ")
                    
                    return LexisDefinition(terms: individualWords)
                }
                else
                {
                   return LexisDefinition(terms: [def])
                }
            }
        
    }
    
    func splitDefinitionsByMeaning(definitions: String) -> [String]
    {
        return definitions.components(separatedBy: ";")
    }
 }
 
 //MARK: Extract Word Type
 extension LexisEngine
 {
    func extractWordType(from line: String, at lineNumber: Int) -> WordType?
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
           let caseText = wordModifiers.second
        {
            let caseType = getCaseForPreposition(from: caseText)
            return WordType.Preposition(caseType)
        }
        
        //Interjections
        if isInterjection(wordModifiers: wordModifiers)
        {
            return WordType.Interjection
        }
        
        //Conjugations
        if isConjugation(wordModifiers: wordModifiers)
        {
            return WordType.Conjunction
        }
        
        if isPronoun(wordModifiers: wordModifiers)
        {
            return WordType.Pronoun
        }
        
        //Personal Pronouns
        if isPersonalPronoun(wordModifiers: wordModifiers)
        {
            return WordType.PersonalPronoun
        }
        
        //Nouns
        if isNoun(wordModifiers: wordModifiers)
        {
            let nounType = getNounType(fromLine: line, withModifiers: wordModifiers)
            warnIfNounIsUndeclined(nounType, line: line)
            return nounType
        }
        
        //Numbers
        if isNumber(wordModifiers: wordModifiers)
        {
            return WordType.Numeral
        }
        
        LOG.info("Could not extract word: \(line)")
        
        return nil
    }
    
    func warnIfNounIsUndeclined(_ wordType: WordType, line: String)
    {
        if case let WordType.Noun(declension, gender) = wordType
        {
            if declension == .Undeclined
            {
                LOG.debug("Noun is Undeclined: \(line)")
            }
        }
    }
    
    func warnIfVerbIsUnconjugated(_ wordType: WordType, line: String)
    {
        if case let WordType.Verb(conjugation, verbType) = wordType
        {
            if conjugation == .Unconjugated
            {
                LOG.debug("Verb is Unconjugated: \(line)")
            }
            
            if conjugation == .Irregular
            {
                LOG.debug("Verb is Irregular: \(line)")
            }
        }
    }
    
    
}


//MARK: Word Type Extraction
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
        else if modifiers.contains(Keywords.semiDeponent)
        {
            return WordType.Verb(conjugation, .SemiDeponent)
        }
        else if modifiers.contains(Keywords.impersonal)
        {
            return WordType.Verb(conjugation, .Impersonal)
        }
        else if modifiers.contains(Keywords.perfectDefinite)
        {
            return WordType.Verb(conjugation, .PerfectDefinite)
        }
        else
        {
            LOG.debug("Unknown Verb Type: \(line)")
            return WordType.Verb(conjugation, .Unknown)
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
            LOG.info("Noun is missing gender: \(line)")
            return WordType.Noun(declension, .Unknown)
        }
    }
    
    func getConjugation(from text: String?) -> Conjugation
    {
        guard let text = text else { return Conjugation.Irregular }
        
        let shortCode = text
        return Conjugation.fromShortCode(code: shortCode)
    }
    
    func getDeclensionForNoun(from declensionText: String?) -> Declension
    {
        guard let shortCode = declensionText else { return .Undeclined }
        
        return Declension.fromShortCode(code: shortCode)
    }
    
    func getCaseForPreposition(from preposition: String) -> CaseType
    {
        let caseShortCode = preposition
        
        return CaseType.from(shortCode: caseShortCode)
    }
    
 }

 //MARK: Word Type Detection
extension LexisEngine
{
    
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
    
    func isPronoun(wordModifiers: [String]) -> Bool
    {
        return wordModifiers.contains(Keywords.pronoun)
    }
    
    func isPersonalPronoun(wordModifiers: [String]) -> Bool
    {
        return wordModifiers.containsMultiple([Keywords.personal, Keywords.pronoun])
    }
    
    func isNumber(wordModifiers: [String]) -> Bool
    {
        return wordModifiers.contains(Keywords.number)
    }
}

 //MARK: Exctract dictionary codes
 extension LexisEngine
 {
    func getSupplementalInformation(fromLine line: String) -> SupplementalInformation?
    {
        let dictionaryCodes = line =~ Regex.dictionaryCode
        
        guard dictionaryCodes.notEmpty
        else
        {
            LOG.warn("No Dictionary codes found for line: \(line)")
            return nil
        }
        
        guard let codeString = dictionaryCodes.first
        else
        {
            LOG.error("Dictionary Codes Regex turned up empty response: \(dictionaryCodes)")
            return nil
        }
        
        let codes = Array(codeString.characters).map() { String.init($0) }
        
        guard codes.count == 5
        else
        {
            LOG.warn("Unepected number of dictionary codes: \(codes)")
            return nil
        }
        
        let ageCode = codes[0]
        let subjectAreCode = codes[1]
        let geographicalAreaCode = codes[2]
        let frequencyCode = codes[3]
        let sourceCode = codes[4]
        
        guard let age = Age.from(dictionaryCode: ageCode)
        else
        {
            LOG.error("Uknown Age code: \(ageCode)")
            return nil
        }
        
        guard let subjectArea = SubjectArea.from(dictionaryCode: subjectAreCode)
        else
        {
            LOG.error("Uknown Subject Area code: \(subjectAreCode)")
            return nil
        }
        
        guard let geographicalArea = GeographicalArea.from(dictionaryCode: geographicalAreaCode)
        else
        {
            LOG.error("Uknown Geographical Area code")
            return nil
        }
        
        guard let frequency = Frequency.from(dictionaryCode: frequencyCode)
        else
        {
            LOG.error("Uknown Frequency code: \(frequencyCode)")
            return nil
        }
        
        guard let source = Source.from(dictionaryCode: sourceCode)
        else
        {
            LOG.error("Uknown Source code: \(sourceCode)")
            return nil
        }
        
        return SupplementalInformation(age: age, subjectArea: subjectArea, geographicalArea: geographicalArea, frequency: frequency, source: source)
    }
    
    
 }
 

//MARK: Dictionary keywords
private class Keywords
{
    static let verb = "V"
    static let transitive = "TRANS"
    static let intransitive = "INTRANS"
    static let deponent = "DEP"
    static let semiDeponent = "SEMIDEP"
    static let impersonal = "IMPERS"
    static let reflexive = "REFLEX"
    static let perfectDefinite = "PERFDEF"
    
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
    
    static let pronoun = "PRON"
    static let personal = "PERS"
    
    static let number = "NUM"
}
