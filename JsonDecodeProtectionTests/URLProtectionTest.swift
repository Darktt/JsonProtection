//
//  URLProtectionTest.swift
//  JsonDecodeProtectionTests
//
//  Created by Eden on 2022/12/16.
//

import XCTest
@testable
import JsonDecodeProtection

struct URLObject: Decodable
{
    @URLProtection
    private(set)
    var homePageUrl: URL?
    
    private(set)
    var detailPageUrl: URL?
}

final class URLProtectionTest: XCTestCase
{
    var jsonString: String!
    
    override func setUpWithError() throws
    {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // Arrange
        
        // Act
        
        // Assert
    }
    
    func testURLProtectionSuccess() throws
    {
        // Arrange
        self.jsonString = """
        {
            "homePageUrl": "",
            "detailPageUrl": "https://www.google.com"
        }
        """
        let jsonData: Data = self.jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        let object = try jsonDecoder.decode(URLObject.self, from: jsonData)
        
        // Assert
        let actualOne: URL? = object.homePageUrl
        let actualTwo: URL? = object.detailPageUrl
        let expect: String = "https://www.google.com"
        
        XCTAssertEqual(actualOne?.absoluteString, nil)
        XCTAssertEqual(actualTwo?.absoluteString, expect)
    }
    
    func testURLProtectionFalse() throws
    {
        // Arrange
        self.jsonString = """
        {
            "homePageUrl": "https://www.google.com",
            "detailPageUrl": ""
        }
        """
        let jsonData: Data = self.jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        var decodeError: Error? = nil
        
        do {
            
            _ = try jsonDecoder.decode(URLObject.self, from: jsonData)
        } catch {
            
            decodeError = error
        }
        
        XCTAssertNotNil(decodeError)
    }
}
