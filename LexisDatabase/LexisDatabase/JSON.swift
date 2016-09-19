//
//  JSON.swift
//  LexisDatabase
//
//  Created by Wellington Moreno on 9/19/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import Foundation
import Sulcus

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
    var asJSON: AnyObject { get }
    
    /**
        This static function creates an instance of the current class
        from the provided JSON.
     
        - returns: An instance of this, if the conversion is successful, `nil` otherwise.
    */
    static func fromJSON(json: AnyObject) -> JSONConvertible?
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
    func toJSON(object: AnyObject) -> String?
    
    /**
        Create a Foundation Object class from the provided JSON String.
    */
    func fromJSON(jsonString: String) -> AnyObject?
}

class JSONSerializationConverter: JSONSerializer
{
    
    private func isJSONCompatible(object: Any) -> Bool
    {
        return JSONSerialization.isValidJSONObject(object)
    }
    
    func toJSON(object: AnyObject) -> String?
    {
        
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
    
    func fromJSON(jsonString string: String) -> AnyObject?
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
