//
//  ObjectProtectionTest.swift
//  JsonProtectionTests
//
//  Created by Darktt on 2022/12/5.
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
    
    @ObjectProtection
    var dices: Array<Int>?
}

extension SomeObject
{
    struct SubObject: Decodable, Equatable
    {
        private(set)
        var name: String?
        
        private(set)
        var number: Int?
        
        static
        func == (lhs: SomeObject.SubObject, rhs: SomeObject.SubObject) -> Bool
        {
            lhs.name == rhs.name && lhs.number == rhs.number
        }
    }
}

struct ObjectProtectionTest
{
    @Test("物件保護在有效 JSON 字串時應該成功解碼")
    func objectProtectionSuccess() throws
    {
        // Arrange
        let jsonString = """
        {
            "subObjects": "[{\\"name\\": \\"Jo\\", \\"number\\": 233}, {\\"name\\": \\"Ana\\", \\"number\\": 4565}]",
            "dices": "[1,5,1]"
        }
        """
        let jsonData: Data = jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        let object = try jsonDecoder.decode(SomeObject.self, from: jsonData)
        
        // Assert
        let actual: String? = object.subObjects?.last?.name
        let expect: String = "Ana"
        
        #expect(actual == expect)
    }
    
    @Test("物件保護應該正確解碼骰子陣列中的數字")
    func objectProtectionDicesSuccess() throws
    {
        // Arrange
        let jsonString = """
        {
            "subObjects": "[{\\"name\\": \\"Jo\\", \\"number\\": 233}, {\\"name\\": \\"Ana\\", \\"number\\": 4565}]",
            "dices": "[1, 5, 1]"
        }
        """
        
        let jsonData: Data = jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        let object = try jsonDecoder.decode(SomeObject.self, from: jsonData)
        
        // Assert
        let actual: Int? = object.dices?[1]
        let expect: Int = 5
        
        #expect(actual == expect)
    }
    
    @Test("物件保護在遇到空字串時應該回傳 nil")
    func objectProtectionWithEmptyString() throws
    {
        // Arrange
        let jsonString = """
        {
            "subObjects": "",
            "dices": "[1, 5, 1]"
        }
        """
        
        let jsonData: Data = jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        let object = try jsonDecoder.decode(SomeObject.self, from: jsonData)
        
        // Assert
        let actual: Array<SomeObject.SubObject>? = object.subObjects
        let expect: Array<SomeObject.SubObject>? = nil
        
        #expect(actual == expect)
    }
}
