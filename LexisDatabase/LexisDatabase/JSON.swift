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
     
        - returns: An instance of this
    */
    static func fromJSON(json: AnyObject) -> JSONConvertible?
}


protocol JSONSerializer
{
    func toJSON(object: AnyObject) -> String?
    
    func fromJSON(jsonString: String) -> AnyObject?
}

class JSONSerializationConverter: JSONSerializer
{
    
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
