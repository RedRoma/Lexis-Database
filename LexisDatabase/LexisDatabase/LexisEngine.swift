//
//  LexisEngine.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 8/27/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
import Sulcus

//The Lexis Engine is reponsible for reading through the Dictionary text file
//And extracting meaningful information from it, for the purpose of
//Storing representing in a LexisWord data structure
public class LexisEngine
{
    
    public let instance = LexisEngine()
    
    private init()
    {
        
    }
    
    
    
}

private extension LexisEngine
{
    
    struct Regex
    {
        
        static let wordType = "(TRANS|V|N|ADJ|ADV|CONJ)"
        static let dictionaryCode = "\\[(\\w+)\\]"
        static let definitionPhrase = "(?<=:: )(.*)"
    }
    
}


//MARK: Loading the text file
extension LexisEngine
{
    
    func readTextFile() -> String?
    {
        
        let resourceName = "LatinDictionary"
        
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: "txt")
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
