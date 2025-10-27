//
//  MultipleKeyProtection.swift
//
//  Created by Darktt on 2022/12/6.
//  Copyright © 2022 Darktt. All rights reserved.
//

@propertyWrapper
public
struct MultipleKeysProtection<DecodeType>: Decodable where DecodeType: Decodable
{
    // MARK: - Properties -
    
    public
    var wrappedValue: DecodeType?
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    public
    init() { }
}

extension MultipleKeysProtection
{
    
}
