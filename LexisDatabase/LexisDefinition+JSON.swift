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
    
    func asJSON() -> Any?
    {
        var dictionary: [String: Any] = [:]
        
        dictionary[key] = (self.terms as NSArray)
        
        return dictionary as NSDictionary
    }
    
    func asJSONString(serializer: JSONSerializer) -> String?
    {
        guard let object = self.asJSON() as? [String: Any]
        else
        {
            LOG.error("Failed to convert self into a JSON Object")
            return nil
        }
        
        let jsonString = serializer.toJSON(object: object)
        return jsonString
    }
    
    static func fromJSON(json: Any) -> JSONConvertible?
    {
        guard let object = json as? [String: Any]
        else
        {
            LOG.error("Expected Dictionary json object, instead :\(json)")
            return nil
        }
        
        let emptyDefinition = LexisDefinition(terms: [])
        
        guard let termsObject = object[key]
            else
        {
            LOG.warn("Missing terms in JSON Object: \(object)")
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
    
    static func fromJSONString(json: String, serializer: JSONSerializer) -> JSONConvertible?
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
        
        return fromJSON(json: dictionary)
    }
}
