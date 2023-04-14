//
//  AESDecoder.swift
//  JsonDecodeProtection
//
//  Created by Eden on 2023/4/10.
//

import Foundation

public protocol AESAdopter
{
    static var key: String { get }
    
    static var iv: String? { get }
    
    static var options: DTAES.Options { get }
}

@propertyWrapper
public struct AESDecoder<Adopter> where Adopter: AESAdopter
{
    // MARK: - Properties -
    
    public var wrappedValue: String?
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    public init(adopter: Adopter.Type) { }
}

extension AESDecoder: Decodable
{
    public init(from decoder: Decoder) throws
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
