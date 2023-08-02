//
//  NumberProtection.swift
//
//  Created by Darktt on 2022/6/21.
//  Copyright © 2022 Darktt. All rights reserved.
//

import Foundation

// MARK: - NumberType -

public protocol NumberType
{
    init?(_ source: String)
    
    init?<T>(_ source: T) where T: BinaryInteger
    
    init?(_ source: Float)
    
    init?(_ source: Double)
}

extension NumberType where Self: RawRepresentable, RawValue: NumberType
{
    public init?(_ source: String)
    {
        guard let rawValue = RawValue(source) else {
            
            return nil
        }
        
        self.init(rawValue: rawValue)
    }
    
    public init?<T>(_ source: T) where T : BinaryInteger
    {
        guard let rawValue = RawValue(source) else {
            
            return nil
        }
        
        self.init(rawValue: rawValue)
    }
    
    public init?(_ source: Float)
    {
        guard let rawValue = RawValue(source) else {
            
            return nil
        }
        
        self.init(rawValue: rawValue)
    }
    
    public init?(_ source: Double)
    {
        guard let rawValue = RawValue(source) else {
            
            return nil
        }
        
        self.init(rawValue: rawValue)
    }
}

extension Int: NumberType { }

extension Float: NumberType { }

extension Double: NumberType { }

// MARK: - NumberProtection -

@propertyWrapper
public struct NumberProtection<DecodeType>: MissingKeyProtecting where DecodeType: Decodable, DecodeType: NumberType
{
    // MARK: - Properties -
    
    public var wrappedValue: DecodeType?
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    public init(wrappedValue: DecodeType?)
    {
        self.wrappedValue = wrappedValue
    }
}

extension NumberProtection: Decodable
{
    public init(from decoder: Decoder) throws
    {
        let container: SingleValueDecodingContainer = try decoder.singleValueContainer()
        
        let wrappedValue: DecodeType? = self.decode(from: container)
        
        self.wrappedValue = wrappedValue
    }
    
    func decode(from container: SingleValueDecodingContainer) -> DecodeType?
    {
        var wrappedValue: DecodeType?
        
        if let string = try? container.decode(String.self) {
            
            wrappedValue = DecodeType(string)
        }
        
        if let integer = try? container.decode(Int.self) {
            
            wrappedValue = DecodeType(integer)
        }
        
        if let float = try? container.decode(Float.self) {
            
            wrappedValue = DecodeType(float)
        }
        
        if let double = try? container.decode(Double.self) {
            
            wrappedValue = DecodeType(double)
        }
        
        return wrappedValue
    }
}

// MARK: - Conform Protocol -

extension NumberProtection: CustomStringConvertible
{
    public var description: String
    {
        self.wrappedValue.map {
            
            "\($0)"
        } ?? "nil"
    }
}

// MARK: - Optional Extension -

private extension Optional
{
    func _compactMap<T>(_ transfrom: (Wrapped) throws -> Optional<T>) rethrows -> Optional<T>
    {
        guard case let .some(unwrapped) = self else {
            
            return nil
        }
        
        let result: Optional<T> = try transfrom(unwrapped)
        
        return result
    }
}
