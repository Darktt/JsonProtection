//
//  NumberArrayProtection.swift
//
//  Created by Darktt on 2024/7/3.
//  Copyright © 2024 Darktt. All rights reserved.
//

import Foundation

@propertyWrapper
public
struct NumberArrayProtection<Element> where Element: Decodable, Element: NumberType
{
    // MARK: - Properties -
    
    public
    typealias WarppedValue = Array<Element>
    
    public
    var wrappedValue: WarppedValue?
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    public
    init() { }
}

// MARK: - Private Methods -

private
extension NumberArrayProtection
{
    private
    func decode(with string: String) throws -> Array<Element>?
    {
        guard !string.isEmpty,
                let data: Data = string.data(using: .utf8) else {
            
            return nil
        }
        
        let jsonDecoder = JSONDecoder()
        let wrapperValue = try jsonDecoder.decode(NumbersProtection<Element>.self, from: data)
        
        return wrapperValue.wrappedValue
    }
}

// MARK: - Conform Protocols -

extension NumberArrayProtection: Decodable
{
    public
    init(from decoder: Decoder) throws
    {
        let container: SingleValueDecodingContainer = try decoder.singleValueContainer()
        
        if container.decodeNil() {
            
            self.wrappedValue = nil
            return
        }
        
        let jsonString: String = try container.decode(String.self)
        let wrappedValue: Array<Element>? = try self.decode(with: jsonString)
        
        self.wrappedValue = wrappedValue
    }
}

extension NumberArrayProtection: CustomStringConvertible
{
    public
    var description: String
    {
        self.wrappedValue.map {
            
            "\($0)"
        } ?? "nil"
    }
}
