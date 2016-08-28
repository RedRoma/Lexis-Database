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
    
    private init()
    {
        
    }
    
    private func initialize()
    {
        
    }
    
    
}

extension LexisEngine
{
    
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
        static let wordModifiers = "(?<= )(INTRANS|TRANS|ADJ|ADV|CONJ|PREP|ACC|INTERJ|V|N|F|M|PRON PERS)(?= )"
        
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
        */
        static let declension = "(?<=[NV] \\()([1-4][a-z]{2})(?=\\))"
    }
    
}


//MARK: Loading the text file
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
