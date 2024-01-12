//
//  AESDecoderTest.swift
//  JsonDecodeProtectionTests
//
//  Created by Eden on 2023/4/10.
//

import XCTest
@testable
import JsonDecodeProtection

struct AESObject: Decodable
{
    @AESDecoder(adopter: AESObject.AESAdopting.self)
    private(set)
    var url: String?
}

struct AESObject2: Decodable
{
    @AESDecoder(adopter: AESObject.AESAdopting.self)
    private(set)
    var urls: Array<String>?
}

extension AESObject
{
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
}

final class AESDecoderTest: XCTestCase
{
    var jsonString: String!
    
    override func setUpWithError() throws
    {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // Arrange
        
        // Act
        
        // Assert
    }
    
    func testAESDecoderSuccess() throws
    {
        // Arrange
        self.jsonString = """
        {
            "url": "0NhMzVQIsjShyNnck3huFVjVCcku2a+iAQVfY3CDrUw="
        }
        """
        let jsonData: Data = self.jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        let object = try jsonDecoder.decode(AESObject.self, from: jsonData)
        
        // Assert
        let url: String? = object.url
        let expect: String = "https://www.apple.com"
        
        XCTAssertEqual(url, expect)
    }
    
    func testDecoderStringArraySuccess() throws
    {
        // Arrange
        self.jsonString = """
        {
            "urls": [
                "0NhMzVQIsjShyNnck3huFVjVCcku2a+iAQVfY3CDrUw=",
                "0NhMzVQIsjShyNnck3huFVjVCcku2a+iAQVfY3CDrUw="
            ]
        }
        """
        let jsonData: Data = self.jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        let object = try jsonDecoder.decode(AESObject2.self, from: jsonData)
        
        // Assert
        let urls: Array<String>? = object.urls
        let expect: Array<String> = ["https://www.apple.com", "https://www.apple.com"]
        
        XCTAssertEqual(urls, expect)
    }
}
