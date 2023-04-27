//
//  ObjectProtection.swift
//
//  Created by Darktt on 22/6/9.
//  Copyright © 2022 Darktt. All rights reserved.
//

import Foundation

/**
 Automatic convert string style json to object.
 
 Usage:
 ```
 struct Foo
 {
     @ObjectProtection<Bar>
     var bar: Bar?
 }
 
 extension Foo: Decodable
 {
     enum CodingKeys: String, CodingKey
     {
         case bar
     }
 }
 
 struct Bar
 {
     let foo: String?
 }
 
 extension Bar: Decodable
 {
     enum CodingKeys: String, CodingKey
     {
         case foo
     }
 }
 
 // ---------------
 
 let jsonString = """
 {
     "bar": "{\\"foo\\":\\"bar\\"}"
 }
 """
 
 do {
    
     try jsonString.data(using: .utf8).map {
         
         let jsonDeocder = JSONDecoder()
         let foo = try jsonDeocder.decode(Foo.self, from: $0)
         
         foo.bar.map {
         
             print("bar: \($0)")
         }
     }
 } catch {
 
     print("\(error)")
 }
 ```
 */
@propertyWrapper
public struct ObjectProtection<Value> where Value: Decodable
{
    // MARK: - Properties -
    
    public var wrappedValue: Value?
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    public init() { }
}

// MARK: - Private Methods -

private extension ObjectProtection
{
    func decode(with string: String) throws -> Value?
    {
        guard let data: Data = string.data(using: .utf8) else {
            
            return nil
        }
        
        let jsonDecoder = JSONDecoder()
        let wrapperValue = try jsonDecoder.decode(Value.self, from: data)
        
        return wrapperValue
    }
}

// MARK: - Conform Protocols -

extension ObjectProtection: Decodable
{
    public init(from decoder: Decoder) throws
    {
        let container: SingleValueDecodingContainer = try decoder.singleValueContainer()
        
        let jsonString: String = try container.decode(String.self)
        let wrappedValue: Value? = try self.decode(with: jsonString)
        
        self.wrappedValue = wrappedValue
    }
}

extension ObjectProtection: CustomStringConvertible
{
    public var description: String
    {
        self.wrappedValue.map {
            
            "\($0)"
        } ?? "nil"
    }
}
