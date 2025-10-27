//
//  URLProtectionTest.swift
//  JsonProtectionTests
//
//  Created by Darktt on 2022/12/16.
//

import Foundation
import Testing
@testable
import JsonProtection

struct URLObject: Decodable
{
    @URLProtection
    private(set)
    var homePageUrl: URL?
    
    private(set)
    var detailPageUrl: URL?
}

struct URLProtectionTest
{
    @Test("URL 保護在遇到空字串時應該對受保護屬性回傳 nil")
    func urlProtectionSuccess() throws
    {
        // Arrange
        let jsonString = """
        {
            "homePageUrl": "",
            "detailPageUrl": "https://www.google.com"
        }
        """
        let jsonData: Data = jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        let object = try jsonDecoder.decode(URLObject.self, from: jsonData)
        
        // Assert
        let actualOne: URL? = object.homePageUrl
        let actualTwo: URL? = object.detailPageUrl
        let expect: String = "https://www.google.com"
        
        #expect(actualOne?.absoluteString == nil)
        #expect(actualTwo?.absoluteString == expect)
    }
    
    @Test("URL 保護在未受保護屬性接收空字串時應該拋出錯誤")
    func urlProtectionFailure() throws
    {
        // Arrange
        let jsonString = """
        {
            "homePageUrl": "https://www.google.com",
            "detailPageUrl": ""
        }
        """
        let jsonData: Data = jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act & Assert
        #expect(throws: (any Error).self) {
            try jsonDecoder.decode(URLObject.self, from: jsonData)
        }
    }
}
