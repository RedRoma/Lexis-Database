//
//  JSON.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/19/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
import Archeota

/**
    A JSONConvertible class is any class that can be converted to
    and from JSON.
 */
protocol JSONConvertible
{
    /**
        A JSON representation of the current class.
     
        - returns: `self` as JSON
    */
    func asJSON() -> Any?
    
    func asJSONString(serializer: JSONSerializer) -> String?
    
    
    /**
        This static function creates an instance of the current class
        from the provided JSON.
     
        - returns: An instance of this, if the conversion is successful, `nil` otherwise.
    */
    static func fromJSON(json: Any) -> JSONConvertible?
    
    static func fromJSONString(json: String, serializer: JSONSerializer) -> JSONConvertible?
}


extension JSONConvertible
{
    func asJSONString(serializer: JSONSerializer) -> String?
    {
        guard let json = self.asJSON()
        else
        {
            LOG.warn("Could not convert self to JSON: \(self)")
            return nil
        }
        
        let jsonString = serializer.toJSON(object: json)
        return jsonString
    }
    
    static func fromJSONString(json: String, serializer: JSONSerializer) -> JSONConvertible?
    {
        guard let object = serializer.fromJSON(jsonString: json)
        else
        {
            LOG.error("Failed to deserialize JSON as an Object: \(json)")
            return nil
        }
        
        return fromJSON(json: object)
    }
}

/**
    A `JSONSerializer` is responsible for converting objects into JSON Strings.
    It is designed to only handle basic object types like `String, Number, Array, Dictionary`.
*/
protocol JSONSerializer
{
    /**
        Convert the object into a JSON String.
    */
    func toJSON(object: Any) -> String?
    
    /**
        Create a Foundation Object class from the provided JSON String.
    */
    func fromJSON(jsonString: String) -> Any?
}

class BasicJSONSerializer: JSONSerializer
{
    
    static let instance = BasicJSONSerializer()
    
    private init()
    {
        
    }
    
    private func isJSONCompatible(object: Any) -> Bool
    {
        return JSONSerialization.isValidJSONObject(object)
    }
    
    func toJSON(object: Any) -> String?
    {
     
        guard isJSONCompatible(object: object)
        else
        {
            LOG.warn("Not JSON Compatibile: \(object)")
            return nil
        }
        
        do
        {
            let data = try JSONSerialization.data(withJSONObject: object, options: [])
            
            if let string = String(data: data, encoding: .utf8)
            {
                return string
            }
            else
            {
                LOG.error("Failed to convert JSON Data into a String")
                return nil
            }
        }
        catch let ex
        {
            LOG.error("Failed to convert \(object) to JSON: \(ex)")
            return nil
        }
    }
    
    func fromJSON(jsonString string: String) -> Any?
    {
        guard let data = string.data(using: .utf8)
        else
        {
            LOG.error("Failed to convert JSON String into a Data packet")
            return nil
        }
        
        do
        {
            let object = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
            return object
        }
        catch let ex
        {
            LOG.error("Failed to convert JSON String into an Object: \(ex)")
            return nil
        }
    }
}
