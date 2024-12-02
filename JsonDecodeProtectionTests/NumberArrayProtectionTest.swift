//
//  NumberArrayProtectionTest.swift
//  JsonDecodeProtectionTests
//
//  Created by Eden on 2024/7/3.
//

import XCTest
@testable
import JsonDecodeProtection

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

final class NumberArrayProtectionTest: XCTestCase 
{
    var jsonString: String!
    
    override func setUpWithError() throws
    {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // Arrange
        
        // Act
        
        // Assert
    }
    
    func testNumberObjectProtectionSuccess() throws
    {
        // Arrange
        self.jsonString = """
        {
            "subObjects": "[{\\"name\\": \\"Jo\\", \\"number\\": 233}, {\\"name\\": \\"Ana\\", \\"number\\": 4565}]",
            "dices": "[1, 5.2, 1.0]"
        }
        """
        let jsonData: Data = self.jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        let object = try jsonDecoder.decode(SomeObject.self, from: jsonData)
        
        // Assert
        let actual: Array<Int>? = object.dices
        let expect: Array<Int> = [1, 5, 1]
        
        XCTAssertEqual(actual, expect)
    }
    
    func testNumberObjectProtectionWithEmptyString() throws
    {
        // Arrange
        self.jsonString = """
        {
            "subObjects": "[{\\"name\\": \\"Jo\\", \\"number\\": 233}, {\\"name\\": \\"Ana\\", \\"number\\": 4565}]",
            "dices": ""
        }
        """
        let jsonData: Data = self.jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        let object = try jsonDecoder.decode(SomeObject.self, from: jsonData)
        
        // Assert
        let actual: Array<Int>? = object.dices
        let expect: Array<Int>? = nil
        
        XCTAssertEqual(actual, expect)
    }
}
