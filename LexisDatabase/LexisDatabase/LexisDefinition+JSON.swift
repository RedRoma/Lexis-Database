//
//  LexisDefinition+JSON.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/19/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
import Sulcus

fileprivate let key = "terms"

extension LexisDefinition: JSONConvertible
{
    
    func asJson(serializer: JSONSerializer) -> String?
    {
        var dictionary: [String: Any] = [:]
        
        guard let termsAsJson = serializer.toJSON(object: self.terms)
        else
        {
            LOG.error("Failed to convert terms into a JSON String")
            return nil
        }
        
        dictionary[key] = termsAsJson
        
        return serializer.toJSON(object: dictionary)
    }
    
    static func fromJSON(json: String, using serializer: JSONSerializer) -> JSONConvertible?
    {
        
        guard let object = serializer.fromJSON(jsonString: json)
        else
        {
            LOG.error("Failed to convert from JSON String: \(json)")
            return nil
        }
        
        guard let dictionary = object as? [String: Any]
        else
        {
            LOG.error("Expecting Dictionary, but instead: \(object)")
            return nil
        }
        
        let emptyDefinition = LexisDefinition(terms: [])
        
        guard let termsObject = dictionary[key]
        else
        {
            LOG.warn("Missing terms in JSON Dictionary: \(dictionary)")
            return emptyDefinition
        }
        
        guard let terms = termsObject as? [String]
        else
        {
            LOG.warn("Expected terms to be a [String], but instead \(termsObject)")
            return emptyDefinition
        }
        
        return LexisDefinition(terms: terms)
        
    }
}
