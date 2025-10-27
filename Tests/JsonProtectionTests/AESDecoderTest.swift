//
//  AESDecoderTest.swift
//  JsonProtectionTests
//
//  Created by Darktt on 2023/4/10.
//

import Foundation
import Testing
@testable
import JsonProtection

#if canImport(CommonCrypto)

struct AESObject: Decodable
{
    @AESDecoder(adopter: AESAdopting.self)
    private(set)
    var url: String?
    
    @AESDecoder(adopter: AESAdopting.self)
    private(set)
    var urls: Array<String>?
}

struct AESAdopting: AESAdopter
{
    static var key: String {
        
        "MnoewgUZrgt5Rk08MtESwHvgzY7ElaEq"
    }
    
    static var iv: String? {
        
        "rtCG5mdgtlCtbyI4"
    }
    
    static var options: DTAES.Options {
        
        [.pkc7Padding, .zeroPadding]
    }
}

struct AESDecoderTest
{
    private
    func createTestObject() throws -> AESObject
    {
        let jsonString: String = """
        {
            "url": "0NhMzVQIsjShyNnck3huFVjVCcku2a+iAQVfY3CDrUw=",
            "urls": [
                "0NhMzVQIsjShyNnck3huFVjVCcku2a+iAQVfY3CDrUw=",
                "0NhMzVQIsjShyNnck3huFVjVCcku2a+iAQVfY3CDrUw="
            ]
        }
        """
        let jsonData: Data = jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        return try jsonDecoder.decode(AESObject.self, from: jsonData)
    }
    
    @Test("AES 解碼器應該正確解密字串值")
    func aesDecoderSuccess() throws
    {
        // Arrange
        let object = try createTestObject()
        
        // Act
        let url: String? = object.url
        let expect: String = "https://www.apple.com"
        
        // Assert
        #expect(url == expect)
    }
    
    @Test("AES 解碼器應該正確解密字串陣列值")
    func decoderStringArraySuccess() throws
    {
        // Arrange
        let object = try createTestObject()
        
        // Act
        let urls: Array<String>? = object.urls
        let expect: Array<String> = ["https://www.apple.com", "https://www.apple.com"]
        
        // Assert
        #expect(urls == expect)
    }
}

#endif // canImport(CommonCrypto)
