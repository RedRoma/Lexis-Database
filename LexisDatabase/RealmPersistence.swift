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
        let realmWords = words.flatMap(RealmWord.from)
        
        try realm.write {
            realmWords.forEach() { word in
                realm.add(word)
            }
        }
        
        LOG.info("Saved \(realmWords.count) words in Realm, at \(realm.configuration.fileURL)")
    }
    
    func getAllWords() -> [LexisWord]
    {
        
        let realmWords = realm.objects(RealmWord.self)
        
        LOG.debug("Found \(realmWords.count) words in Realm")
        
        return realmWords.map() { $0.asLexisWord }
            .sorted() { left, right in
                let leftForm = left.forms.first ?? ""
                let rightForm = right.forms.first ?? ""
                return leftForm < rightForm
            }
    }
    
    func getAnyWord() -> LexisWord?
    {
        return realm.objects(RealmWord.self).any?.asLexisWord
    }
    
    func removeAll()
    {
        try? realm.write {
            realm.deleteAll()
//            Realm.deleteDatabase()
        }
    }
    
    func remove(word: LexisWord)
    {
        guard let realmWord = RealmWord.from(lexisWord: word) else { return }
        
        try? realm.write {
            realm.delete(realmWord)
            LOG.debug("Deleted word from Realm: \(word)")
        }
    }
    
    func searchForWords(startingWith term: String) -> [LexisWord]
    {
        let predicate = NSPredicate(format: "SUBQUERY(forms, $form, $form.form BEGINSWITH %@) .@count > 0", term)
        
        let results = realm.objects(RealmWord.self).filter(predicate)
        return results.map() { $0.asLexisWord }
    }
    
    func searchForWords(inWordList terms: String) -> [LexisWord]
    {
        let predicate = NSPredicate(format: "SUBQUERY(forms, $form, $form.form CONTAINS %@) .@count > 0", terms)
        
        let results = realm.objects(RealmWord.self).filter(predicate)
        return results.map() { $0.asLexisWord }
    }
    
    func searchForWords(inDefinition terms: String) -> [LexisWord]
    {
        let predicate = NSPredicate(format: "SUBQUERY(definitions, $definition, ANY SUBQUERY($definition.terms, $term, $term CONTAINS %@) .@count > 0) .@count > 0", terms)
        
        let results = realm.objects(RealmWord.self).filter() { word in
            let definitions: [LexisDefinition] = word.definitions.map() { $0.asLexisDefinition }
            
            let shouldMatch: (LexisDefinition) -> (Bool) = { definition in
                
                return definition.terms.anyMatch(shouldMatch: { $0.contains(terms) })
            }
            
            return definitions.anyMatch(shouldMatch: shouldMatch)
        }
        return results.map() { $0.asLexisWord }
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
        
        let supplementalInformation = lexisWord.supplementalInformation.asJSONString(serializer: RealmWord.json) ?? ""
    
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
        
        if let parsedSupplementalInfo = SupplementalInformation.fromJSONString(json: self.supplementalInformation, serializer: RealmWord.json) as? SupplementalInformation
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

extension Results
{
    var notEmpty: Bool { return !isEmpty }
    
    var any: T?
    {
        guard !notEmpty else { return nil }
        
        var index = Int(arc4random_uniform(UInt32(count)))
        
        //Ensure Index is greater than 0
        if index < 0
        {
            index = 0
        }
        
        if index >= count
        {
            index = count - 1
        }
        
        return self[index]
        
    }
}
