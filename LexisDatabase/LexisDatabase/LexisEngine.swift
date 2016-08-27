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
public class LexisEngine
{
    
    public static let instance = LexisEngine()
    
    private init()
    {
        
    }
    
    
    
}

extension LexisEngine
{
    
    struct Regex
    {
        
        static let wordType = "(TRANS|V|N|ADJ|ADV|CONJ)"
        static let dictionaryCode = "(?<=\\[)([A-Z]{5})(?=\\])"
        static let definitionPhrase = "(?<=:: )(.*)"
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
