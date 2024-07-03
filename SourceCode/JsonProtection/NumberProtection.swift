//
//  NumberProtection.swift
//
//  Created by Darktt on 2022/6/21.
//  Copyright © 2022 Darktt. All rights reserved.
//

import Foundation

// MARK: - NumberType -

public 
protocol NumberType
{
    init?(_ source: String)
    
    init?(_ source: Decimal)
    
    init?<T>(_ source: T) where T: BinaryInteger
    
    init?(_ source: Float)
    
    init?(_ source: Double)
}

extension NumberType where Self: RawRepresentable, RawValue: NumberType
{
    public
    init?(_ source: String)
    {
        guard let rawValue = RawValue(source) else {
            
            return nil
        }
        
        self.init(rawValue: rawValue)
    }
    
    public
    init?(_ source: Decimal)
    {
        guard let rawValue = RawValue(source) else {
            
            return nil
        }
        
        self.init(rawValue: rawValue)
    }
    
    public
    init?<T>(_ source: T) where T : BinaryInteger
    {
        guard let rawValue = RawValue(source) else {
            
            return nil
        }
        
        self.init(rawValue: rawValue)
    }
    
    public
    init?(_ source: Float)
    {
        guard let rawValue = RawValue(source) else {
            
            return nil
        }
        
        self.init(rawValue: rawValue)
    }
    
    public
    init?(_ source: Double)
    {
        guard let rawValue = RawValue(source) else {
            
            return nil
        }
        
        self.init(rawValue: rawValue)
    }
}

extension Decimal: NumberType
{
    public
    init?(_ source: String)
    {
        self.init(string: source)
    }
    
    public
    init?(_ source: Decimal)
    {
        self = source
    }
    
    public
    init?<T>(_ source: T) where T : BinaryInteger
    {
        guard let value = source as? Int else {
            
            return nil
        }
        
        self.init(string: "\(value)")
    }
    
    public
    init?(_ source: Float)
    {
        let value = String(source)
        
        self.init(string: value)
    }
}

extension Int: NumberType
{
    public
    init?(_ source: String)
    {
        guard let decimal = Decimal(source) else {
            
            return nil
        }
        
        self.init(decimal)
    }
    
    public
    init?(_ source: Decimal)
    {
        let number = NSDecimalNumber(decimal: source)
        
        self.init(truncating: number)
    }
}

extension Int32: NumberType
{
    public
    init?(_ source: String)
    {
        guard let decimal = Decimal(source) else {
            
            return nil
        }
        
        self.init(decimal)
    }
    
    public
    init?(_ source: Decimal)
    {
        let number = NSDecimalNumber(decimal: source)
        
        self.init(truncating: number)
    }
}

extension UInt: NumberType
{
    public
    init?(_ source: String)
    {
        guard let decimal = Decimal(source) else {
            
            return nil
        }
        
        self.init(decimal)
    }
    
    public
    init?(_ source: Decimal)
    {
        let number = NSDecimalNumber(decimal: source)
        
        self.init(truncating: number)
    }
}

extension UInt32: NumberType
{
    public
    init?(_ source: String)
    {
        guard let decimal = Decimal(source) else {
            
            return nil
        }
        
        self.init(decimal)
    }
    
    public
    init?(_ source: Decimal)
    {
        let number = NSDecimalNumber(decimal: source)
        
        self.init(truncating: number)
    }
}

extension Float: NumberType
{
    public
    init?(_ source: Decimal)
    {
        let number = NSDecimalNumber(decimal: source)
        
        self.init(truncating: number)
    }
}

extension Double: NumberType
{
    public
    init?(_ source: Decimal)
    {
        let number = NSDecimalNumber(decimal: source)
        
        self.init(truncating: number)
    }
}

// MARK: - NumberProtection -

@propertyWrapper
public
struct NumberProtection<DecodeType>: MissingKeyProtecting where DecodeType: Decodable, DecodeType: NumberType
{
    // MARK: - Properties -
    
    public
    var wrappedValue: DecodeType?
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    public
    init(wrappedValue: DecodeType?)
    {
        self.wrappedValue = wrappedValue
    }
}

extension NumberProtection
{
    public 
    init(from decoder: Decoder) throws
    {
        let container: SingleValueDecodingContainer = try decoder.singleValueContainer()
        
        let wrappedValue: DecodeType? = self.decode(from: container)
        
        self.wrappedValue = wrappedValue
    }
    
    private
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
        
        if let decimal = try? container.decode(Decimal.self), DecodeType.self == Decimal.self {
            
            wrappedValue = DecodeType(decimal)
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
