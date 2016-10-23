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
    var forms = List<RealmForm>()
    
    var definitions = List<RealmDefinition>()
    
    dynamic var wordType = ""
    
    static func from(lexisWord: LexisWord) -> RealmWord?
    {
        let forms = lexisWord.forms.map(RealmForm.from)
        
        let definitions = lexisWord.definitions.map(RealmDefinition.from)
        
        guard let wordType = lexisWord.wordType.asJSONString(serializer: BasicJSONSerializer.instance) else {
            return nil
        }
    
        let realmWord = RealmWord()
        realmWord.forms = List(forms)
        realmWord.definitions = List(definitions)
        realmWord.wordType = wordType
        
        return realmWord
    }
    
}
