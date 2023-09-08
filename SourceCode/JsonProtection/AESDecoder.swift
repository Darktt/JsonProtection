//
//  AESDecoder.swift
//
//  Created by Darktt on 2023/4/10.
//  Copyright © 2023 Darktt. All rights reserved.
//

import Foundation

// MARK: - AESAdopter -

public
protocol AESAdopter
{
    static var key: String { get }
    
    static var iv: String? { get }
    
    static var options: DTAES.Options { get }
}

// MARK: - AESDecoder -

@propertyWrapper
public
struct AESDecoder<Adopter> where Adopter: AESAdopter
{
    // MARK: - Properties -
    
    public
    var wrappedValue: String?
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    public
    init(adopter: Adopter.Type) { }
}

// MARK: - Conform Protocols -

extension AESDecoder: Decodable
{
    public
    init(from decoder: Decoder) throws
    {
        let container: SingleValueDecodingContainer = try decoder.singleValueContainer()
        let encryptedString: String = try container.decode(String.self)
        let aes = DTAES(encryptedString)
        aes.setKey(Adopter.key)
        Adopter.iv.map {
            
            aes.setIv($0)
        }
        aes.operation = .decrypt
        aes.options = Adopter.options
        
        let decryptedString: String = try aes.result()
        
        self.wrappedValue = decryptedString
    }
}
