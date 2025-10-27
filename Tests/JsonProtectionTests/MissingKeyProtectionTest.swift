//
//  MissingKeyProtectionTest.swift
//  JsonProtectionTests
//
//  Created by Darktt on 2022/12/2.
//

import Foundation
import Testing
@testable
import JsonProtection

private
struct MissingKeyObject: Decodable
{
    @MissingKeyProtection
    private(set)
    var existKey: String?
    
    @MissingKeyProtection
    private(set)
    var missingKey: String?
}

struct MissingKeyProtectionTest
{
    @Test("缺失鍵保護應該優雅地處理缺失的鍵")
    func missingKeyProtectionSuccess() throws
    {
        // Arrange
        let jsonString = """
        {
            "existKey": "Something"
        }
        """
        let jsonData: Data = jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        let object = try jsonDecoder.decode(MissingKeyObject.self, from: jsonData)
        
        // Assert
        #expect(object.existKey == "Something")
        #expect(object.missingKey == nil)
    }
}
