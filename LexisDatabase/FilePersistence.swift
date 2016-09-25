//
//  FilePersistence.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/25/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
import Sulcus

class FilePersistence: LexisPersistence
{
    private let filePath = NSHomeDirectory().appending("/Library/Caches/LexisWords.txt")
    
    
    private init() {}
    
    static let instance = FilePersistence()
    
    func getAllWords() -> [LexisWord]
    {
        LOG.info("Reading words from file")
        guard let array = NSArray(contentsOfFile: filePath)
        else
        {
            LOG.info("Words not found in file \(filePath)")
            return []
        }
        LOG.info("Read \(array.count) words from file")
        
        guard let objects = array as? [NSDictionary]
        else
        {
            LOG.info("Words found in incorrect format")
            return []
        }
        
        LOG.info("Deserializing \(objects.count) words")
        
        let words = objects.flatMap() { object in
            return (LexisWord.fromJSON(json: object) as? LexisWord)
        }
        
        LOG.info("Deserialized \(words.count) words")
        return words
    }
    
    func save(words: [LexisWord]) throws
    {
        LOG.info("Serializing \(words.count)")
        let array = words.flatMap() { $0.asJSON() as? NSDictionary }
        LOG.info("Serialized \(array.count) words from \(words.count)")
        
        let nsArray = NSArray(array: array)
        
        LOG.info("Writing \(nsArray.count) words to file: \(filePath)")
        let wasSuccessful = nsArray.write(toFile: filePath, atomically: true)
        
        if wasSuccessful
        {
            LOG.info("Wrote \(nsArray.count) words to \(filePath)")
        }
        else
        {
            LOG.warn("Could not save words to \(filePath)")
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
