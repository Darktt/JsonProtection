//
//  URLProtection.swift
//
//  Created by Darktt on 2022/7/7.
//  Copyright © 2022 Darktt. All rights reserved.
//

import Foundation

@propertyWrapper
public
struct URLProtection
{
    // MARK: - Properties -
    
    public
    var wrappedValue: URL?
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    public
    init() { }
}

// MARK: - Conform Protocols -

extension URLProtection: Decodable
{
    public
    init(from decoder: Decoder) throws
    {
        let container: SingleValueDecodingContainer = try decoder.singleValueContainer()
        
        let urlString: String = try container.decode(String.self)
        let url = URL(string: urlString)
        
        self.wrappedValue = url
    }
}

extension URLProtection: CustomStringConvertible
{
    public
    var description: String
    {
        self.wrappedValue.map {
            
            "\($0)"
        } ?? "nil"
    }
}
