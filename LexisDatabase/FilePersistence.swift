//
//  FilePersistence.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/25/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
import Archeota

class FilePersistence: LexisPersistence
{
    private let filePath = NSHomeDirectory().appending("/Library/Caches/LexisWords.json")
    
    static let instance = FilePersistence()
    
    private let parallelism = 6
    private let async: OperationQueue
    private let serializer = BasicJSONSerializer.instance
    
    private init()
    {
        async = OperationQueue()
        async.maxConcurrentOperationCount = parallelism
    }
    
    
    func getAllWords() -> [LexisWord]
    {
        LOG.info("Reading words from file :\(filePath)")
        
        guard let json = try? String(contentsOfFile: filePath)
        else
        {
            LOG.info("Failed to read JSON from file \(filePath)")
            return []
        }
        
        guard let array = serializer.fromJSON(jsonString: json) as? NSArray
        else
        {
            LOG.info("Words not found in file \(filePath)")
            return []
        }
        
        LOG.info("Read \(array.count) words from file: \(filePath)")
        
        guard let objects = array as? [NSDictionary]
        else
        {
            LOG.info("Words found in incorrect format")
            return []
        }
        
        LOG.info("Deserializing \(objects.count) words")
        
        let pieces = objects.split(into: parallelism)
        var lexisWords = [LexisWord]()
        
        LOG.debug("Converting objects in \(pieces.count) threads")
        
        var completed = 0
        var stillWorking: Bool { return completed < pieces.count }
        
        for words in pieces {
            
            async.addOperation() {
                
                let convertedWords = words.flatMap() { dictionary in
                    return (LexisWord.fromJSON(json: dictionary) as? LexisWord)
                }
                
                lexisWords += convertedWords
                LOG.debug("Converted \(convertedWords.count) words")
                completed += 1
            }
        }
        
        async.waitUntilAllOperationsAreFinished()
        while stillWorking { /* wait */ }
        
        LOG.info("Deserialized \(lexisWords.count) words")
        return lexisWords
    }
    
    func save(words: [LexisWord]) throws
    {
        LOG.info("Serializing \(words.count)")
        let array = words.flatMap() { $0.asJSON() as? NSDictionary }
        LOG.info("Serialized \(array.count) words from \(words.count)")
        
        let nsArray = NSArray(array: array)
        
        guard let jsonString = serializer.toJSON(object: nsArray)
        else
        {
            LOG.warn("Failed to convert array to JSON")
            throw LexisPersistenceError.ConversionError
        }
        
        LOG.info("Writing \(nsArray.count) words to JSON File: \(filePath)")
        
        do
        {
            try jsonString.write(toFile: filePath, atomically: true, encoding: .utf8)
            LOG.info("Wrote words to JSON file")
        }
        catch
        {
            LOG.error("Failed to write JSON to file \(filePath) : \(error)")
            throw LexisPersistenceError.IOError
        }
    }
    
    func removeAll()
    {
        let fileManager = FileManager()
        
        guard fileManager.fileExists(atPath: filePath)
        else
        {
            LOG.info("Skipping delete of file \(filePath) since it does not exist")
            return
        }
        
        do
        {
            try fileManager.removeItem(atPath: filePath)
            LOG.info("Deleted file at \(filePath)")
        }
        catch
        {
            LOG.error("Failed to delete file at \(filePath): \(error)")
        }
        
    }
}
