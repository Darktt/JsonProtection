//
//  AESDecoderTest.swift
//  JsonDecodeProtectionTests
//
//  Created by Eden on 2023/4/10.
//

import XCTest
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

final
class AESDecoderTest: XCTestCase
{
    var object: AESObject?
    
    override
    func setUpWithError() throws
    {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // Arrange
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
        
        // Act
        let object = try jsonDecoder.decode(AESObject.self, from: jsonData)
        self.object = object
        
        // Assert
    }
    
    override func tearDown() {
        super.tearDown()
        // 確保每個測試案例結束後清理狀態
    }
    
    func testAESDecoderSuccess() throws
    {
        // Arrange
        guard let object: AESObject = self.object else {
            
            XCTFail("Object should not be nil")
            return
        }
        
        // Act
        let url: String? = object.url
        let expect: String = "https://www.apple.com"
        
        // Assert
        XCTAssertEqual(url, expect)
    }
    
    func testDecoderStringArraySuccess() throws
    {
        // Arrange
        guard let object: AESObject = self.object else {
            
            XCTFail("Object should not be nil")
            return
        }
        
        // Act
        let urls: Array<String>? = object.urls
        let expect: Array<String> = ["https://www.apple.com", "https://www.apple.com"]
        
        // Assert
        XCTAssertEqual(urls, expect)
    }
}

#endif // canImport(CommonCrypto)
