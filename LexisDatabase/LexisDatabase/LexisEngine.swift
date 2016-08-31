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
        
        let words = extractWordsFrom(line: line)
        
        print(words)
        
        return nil
    }
    
    func extractWordsFrom(line: String) -> [String]
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
