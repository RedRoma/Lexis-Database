//
//  RealmPersistence.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 10/22/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Archeota
import Foundation
import RealmSwift


class RealmPersistence: LexisPersistence
{

    static let instance = RealmPersistence()!
    
    fileprivate let realm: Realm
    
    init?()
    {
        do
        {
            try self.realm = Realm()
        }
        catch
        {
            LOG.error("Failed to load Realm: \(error)")
            return nil
        }
    }
    
    
    func save(words: [LexisWord]) throws
    {
        
    }
    
    func getAllWords() -> [LexisWord]
    {
        return []
    }
    
    func removeAll()
    {
        
    }
    
    func remove(word: LexisWord)
    {
        
    }
    
    func searchForWords(inWordList terms: String) -> [LexisWord]
    {
        return []
    }
    
    func searchForWords(inDefinition terms: String) -> [LexisWord]
    {
        return []
    }
    
}

class RealmForm: Object
{
    dynamic var form = ""
    
    static func from(form: String) -> RealmForm
    {
        let realmForm = RealmForm()
        realmForm.form = form
        return realmForm
    }
    
    var asString: String { return form }
}


class RealmDefinitionTerm: Object
{
    dynamic var term = ""
    
    static func from(term: String) -> RealmDefinitionTerm
    {
        let instance = RealmDefinitionTerm()
        instance.term = term
    
        return instance
    }
    
    var asString: String { return term }
}

class RealmDefinition: Object
{
    var terms = List<RealmDefinitionTerm>()
    
    static func from(lexisDefinition: LexisDefinition) -> RealmDefinition
    {
        
        let terms = lexisDefinition.terms.map(RealmDefinitionTerm.from)
        
        let definition = RealmDefinition()
        definition.terms = List(terms)
        
        return definition
    }
    
    var asLexisDefinition: LexisDefinition
    {
        let terms: [String] = self.terms.map() { $0.asString }
        
        return LexisDefinition(terms: terms)
    }
}

class RealmWord: Object
{
    
    private static let json = BasicJSONSerializer.instance
    
    var forms = List<RealmForm>()
    
    var definitions = List<RealmDefinition>()
    
    dynamic var supplementalInformation = ""
    
    dynamic var wordType = ""
    
    static func from(lexisWord: LexisWord) -> RealmWord?
    {
        let forms = lexisWord.forms.map(RealmForm.from)
        let definitions = lexisWord.definitions.map(RealmDefinition.from)
        
        guard let wordType = lexisWord.wordType.asJSONString(serializer: RealmWord.json) else {
            return nil
        }
        
        let supplementalInformation = RealmWord.json.toJSON(object: lexisWord.supplementalInformation.asJSON()) ?? ""
    
        let realmWord = RealmWord()
        realmWord.forms = List(forms)
        realmWord.definitions = List(definitions)
        realmWord.supplementalInformation = supplementalInformation
        realmWord.wordType = wordType
        
        return realmWord
    }
    
    var asLexisWord: LexisWord
    {
        let forms: [String] = self.forms.map() { $0.asString }
        let definitions: [LexisDefinition] = self.definitions.map() { $0.asLexisDefinition }

        let supplementalInfo: SupplementalInformation
        
        if let supplementalInfoDictionary = RealmWord.json.fromJSON(jsonString: self.supplementalInformation) as? NSDictionary,
            let parsedSupplementalInfo = SupplementalInformation.fromJSON(json: supplementalInfoDictionary) as? SupplementalInformation
        {
            supplementalInfo = parsedSupplementalInfo
        }
        else
        {
            supplementalInfo = SupplementalInformation.unknown
        }
        
        
        let wordType = WordType.fromJSONString(json: self.wordType, serializer: BasicJSONSerializer.instance) as! WordType
        
        return LexisWord(forms: forms, wordType: wordType, definitions: definitions, supplementalInformation: supplementalInfo)
    }
}

extension Realm
{
    static func deleteDatabase()
    {
        guard let path = Realm.Configuration.defaultConfiguration.fileURL else { return }
        
        let fileManager = FileManager()
        do
        {
            try fileManager.removeItem(at: path)
        }
        catch
        {
            LOG.error("Failed to delete Realm Database at \(path)")
        }
    }
}
