//
//  NumberArrayProtectionTest.swift
//  JsonProtectionTests
//
//  Created by Darktt on 2024/7/3.
//

import Foundation
import Testing
@testable
import JsonProtection

private
struct SomeObject: Decodable
{
    @ObjectProtection
    var subObjects: Array<SubObject>?
    
    @NumberArrayProtection
    var dices: Array<Int>?
}

extension SomeObject
{
    struct SubObject: Decodable
    {
        private(set)
        var name: String?
        
        private(set)
        var number: Int?
    }
}

struct NumberArrayProtectionTest
{
    @Test("數字陣列保護應該正確解碼數字陣列")
    func numberObjectProtectionSuccess() throws
    {
        // Arrange
        let jsonString = """
        {
            "subObjects": "[{\\"name\\": \\"Jo\\", \\"number\\": 233}, {\\"name\\": \\"Ana\\", \\"number\\": 4565}]",
            "dices": "[1, 5.2, 1.0]"
        }
        """
        let jsonData: Data = jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        let object = try jsonDecoder.decode(SomeObject.self, from: jsonData)
        
        // Assert
        let actual: Array<Int>? = object.dices
        let expect: Array<Int> = [1, 5, 1]
        
        #expect(actual == expect)
    }
    
    @Test("數字陣列保護在遇到空字串時應該回傳 nil")
    func numberObjectProtectionWithEmptyString() throws
    {
        // Arrange
        let jsonString = """
        {
            "subObjects": "[{\\"name\\": \\"Jo\\", \\"number\\": 233}, {\\"name\\": \\"Ana\\", \\"number\\": 4565}]",
            "dices": ""
        }
        """
        let jsonData: Data = jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        let object = try jsonDecoder.decode(SomeObject.self, from: jsonData)
        
        // Assert
        let actual: Array<Int>? = object.dices
        let expect: Array<Int>? = nil
        
        #expect(actual == expect)
    }
}
