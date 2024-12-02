//
//  ObjectProtectionTest.swift
//  JsonDecodeProtectionTests
//
//  Created by Darktt on 2022/12/5.
//

import XCTest
@testable
import JsonDecodeProtection

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

final class ObjectProtectionTest: XCTestCase
{
    var jsonString: String!
    
    override func setUpWithError() throws
    {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // Arrange
        
        // Act
        
        // Assert
    }
    
    func testObjectProtectionSuccess() throws
    {
        // Arrange
        self.jsonString = """
        {
            "subObjects": "[{\\"name\\": \\"Jo\\", \\"number\\": 233}, {\\"name\\": \\"Ana\\", \\"number\\": 4565}]",
            "dices": "[1,5,1]"
        }
        """
        let jsonData: Data = self.jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        let object = try jsonDecoder.decode(SomeObject.self, from: jsonData)
        
        // Assert
        let actual: String? = object.subObjects?.last?.name
        let expect: String = "Ana"
        
        XCTAssertEqual(actual, expect)
    }
    
    func testObjectProtectionDicesSuccess() throws
    {
        // Arrange
        self.jsonString = """
        {
            "subObjects": "[{\\"name\\": \\"Jo\\", \\"number\\": 233}, {\\"name\\": \\"Ana\\", \\"number\\": 4565}]",
            "dices": "[1, 5, 1]"
        }
        """
        
        let jsonData: Data = self.jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        let object = try jsonDecoder.decode(SomeObject.self, from: jsonData)
        
        // Assert
        let actual: Int? = object.dices?[1]
        let expect: Int = 5
        
        XCTAssertEqual(actual, expect)
    }
    
    func testObjectProtectionWithEmptyString() throws
    {
        // Arrange
        self.jsonString = """
        {
            "subObjects": "",
            "dices": "[1, 5, 1]"
        }
        """
        
        let jsonData: Data = self.jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        let object = try jsonDecoder.decode(SomeObject.self, from: jsonData)
        
        // Assert
        let actual: Array<SomeObject.SubObject>? = object.subObjects
        let expect: Array<SomeObject.SubObject>? = nil
        
        XCTAssertEqual(actual, expect)
    }
}
