//
//  AESDecoder.swift
//
//  Created by Darktt on 2023/4/10.
//  Copyright © 2023 Darktt. All rights reserved.
//

// MARK: - AESAdopter -

public
protocol AESAdopter
{
    static var key: String { get }
    
    static var iv: String? { get }
    
    static var options: DTAES.Options { get }
}

// MARK: - AESDecodable -

public
protocol AESDecodable: Decodable { }

extension String: AESDecodable { }

extension Array: AESDecodable where Element == String { }

// MARK: - AESDecoder -

@propertyWrapper
public
struct AESDecoder<Adopter, Value> where Adopter: AESAdopter, Value: AESDecodable
{
    // MARK: - Properties -
    
    public
    var wrappedValue: Value?
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    public
    init(adopter: Adopter.Type) { }
}

// MARK: - Private Methods -

private
extension AESDecoder
{
    func decodeString(_ string: String) throws -> String
    {
        let aes = DTAES(string)
        aes.setKey(Adopter.key)
        Adopter.iv.map {
            
            aes.setIv($0)
        }
        aes.operation = .decrypt
        aes.options = Adopter.options
        
        let decryptedString: String = try aes.result()
        
        return decryptedString
    }
    
    func decodeArray(_ array: Array<String>) throws -> Array<String>
    {
        let decryptedArray: Array<String> = try array.map {
            
            try self.decodeString($0)
        }
        
        return decryptedArray
    }
}


// MARK: - Conform Protocols -

extension AESDecoder: Decodable
{
    public
    init(from decoder: Decoder) throws
    {
        let container: SingleValueDecodingContainer = try decoder.singleValueContainer()
        let encryptedValue: Value? = try? container.decode(Value.self)
        
        if let encryptedString = encryptedValue as? String {
            
            let decodeValue: String? = try? self.decodeString(encryptedString)
            self.wrappedValue = decodeValue as? Value
            
            return
        }
        
        if let encryptedArray = encryptedValue as? Array<String> {
            
            let decodeValue: Array<String>? = try? self.decodeArray(encryptedArray)
            self.wrappedValue = decodeValue as? Value
            
            return
        }
    }
}
