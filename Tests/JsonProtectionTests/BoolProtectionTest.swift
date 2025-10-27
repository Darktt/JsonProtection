//
//  BoolProtectionTest.swift
//  JsonProtectionTests
//
//  Created by Darktt on 2022/11/30.
//

import Foundation
import Testing
@testable
import JsonProtection

private
struct BoolObject: Decodable
{
    @BoolProtection
    private(set)
    var `true`: Bool?
    
    @BoolProtection
    private(set)
    var `false`: Bool?
}

struct BoolProtectionTest
{
    @Test("布林保護應該正確解碼布林值")
    func boolProtectionSuccess() throws
    {
        // Arrange
        let jsonString = """
        {
            "true": true,
            "false": "FALSE"
        }
        """
        let jsonData: Data = jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        let object = try jsonDecoder.decode(BoolObject.self, from: jsonData)
        
        // Assert
        #expect(object.true == true)
        #expect(object.false == false)
    }
    
    @Test("布林保護應該對無效的布林值拋出錯誤")
    func boolProtectionFailure() throws
    {
        // Arrange
        let jsonString = """
        {
            "true": 4,
            "false": "FALSE"
        }
        """
        let jsonData: Data = jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act & Assert
        #expect(throws: DecodingError.self) {
            try jsonDecoder.decode(BoolObject.self, from: jsonData)
        }
    }
}
