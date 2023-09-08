//
//  NumbersProtection.swift
//
//  Created by Darktt on 2022/7/14.
//  Copyright © 2022 Darktt. All rights reserved.
//

import Foundation

@propertyWrapper
public
struct NumbersProtection<Element>: MissingKeyProtecting where Element: Decodable, Element: NumberType
{
    // MARK: - Properties -
    
    public
    var wrappedValue: Array<Element>?
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    public
    init(wrappedValue: Array<Element>?)
    {
        self.wrappedValue = wrappedValue
    }
}

extension NumbersProtection: Decodable
{
    public
    init(from decoder: Decoder) throws
    {
        let container: SingleValueDecodingContainer = try decoder.singleValueContainer()
        
        if container.decodeNil() {
            
            self.wrappedValue = nil
            return
        }
        
        let wrappedValue: Array<Element>? = self.decode(from: container)
        
        self.wrappedValue = wrappedValue
    }
    
    func decode(from container: SingleValueDecodingContainer) -> Array<Element>?
    {
        var wrappedValue: Array<Element>?
        
        if let strings = try? container.decode(Array<String>.self) {
            
            wrappedValue = strings.compactMap(Element.init(_:))
        }
        
        if let integers = try? container.decode(Array<Int>.self) {
            
            wrappedValue = integers.compactMap(Element.init(_:))
        }
        
        if let floats = try? container.decode(Array<Float>.self) {
            
            wrappedValue = floats.compactMap(Element.init(_:))
        }
        
        if let doubles = try? container.decode(Array<Double>.self) {
            
            wrappedValue = doubles.compactMap(Element.init(_:))
        }
        
        return wrappedValue
    }
}

// MARK: - Conform Protocol -

extension NumbersProtection: CustomStringConvertible
{
    public
    var description: String
    {
        self.wrappedValue.map {
            
            "\($0)"
        } ?? "nil"
    }
}
