//
//  NilProtection.swift
//
//  Created by Eden on 2022/6/14.
//  Copyright © 2022 Darktt. All rights reserved.
//

import Foundation

// MARK: - NilProtecting -

public protocol NilProtecting: Decodable
{
    associatedtype WrappedType: ExpressibleByNilLiteral
    
    init(wrappedValue: WrappedType)
}

// MARK: - NilProtection -

/**
 Handle json key maybe not exist issue.
 
 Usage:
 ```
 struct Foo
 {
    var foo: [String]?
    
    @NilProtection
    var third: String?
 }
 
 extension Foo: Decodable
 {
     enum CodingKeys: String, CodingKey
     {
         case foo
         
         case third
     }
 }
 
 // ---------------
 
 let jsonString = """
 {
     "foo": "["1", "2", "3", "4", "5", "6"]
 }
 """
 
 do {
    
     try jsonString.data(using: .utf8).map {
         
         let jsonDeocder = JSONDecoder()
         let jsonObject = try jsonDeocder.decode(Foo.self, from: $0)
         
         print("third: \(jsonObject.third ?? "nil")")
     }
 } catch {
 
     print("\(error)")
 }
 ```
 */
@propertyWrapper
public struct NilProtection<Value>: NilProtecting where Value: Decodable
{
    // MARK: - Properties -
    
    public var wrappedValue: Value?
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    public init(wrappedValue: Value?)
    {
        self.wrappedValue = wrappedValue
    }
}

// MARK: - Conform Protocols -

extension NilProtection: Decodable
{
    public init(from decoder: Decoder) throws
    {
        let container = try decoder.singleValueContainer()
        let wrappedValue: Value? = try? container.decode(Value.self)
        
        self.wrappedValue = wrappedValue
    }
}

extension NilProtection: CustomStringConvertible
{
    public var description: String
    {
        self.wrappedValue.map {
            
            "\($0)"
        } ?? "nil"
    }
}

// MARK: - KeyedDecodingContainer extension -

extension KeyedDecodingContainer
{
    public func decode<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T where T: NilProtecting
    {
        let result: T = try self.decodeIfPresent(T.self, forKey: key) ?? T(wrappedValue: nil)
        
        return result
    }
}
