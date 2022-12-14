//
//  NumberProtectionTest.swift
//  JsonDecodeProtectionTests
//
//  Created by Darktt on 2022/12/7.
//

import XCTest
@testable
import JsonDecodeProtection

struct NumberObject: Decodable
{
    @NumberProtection
    private(set)
    var index: Int?
}

final class NumberProtectionTest: XCTestCase
{
    var jsonString: String!
    
    override func setUpWithError() throws
    {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // Arrange
        
        // Act
        
        // Assert
    }
    
    func testNumberProtectionSuccess() throws
    {
        // Arrange
        self.jsonString = """
        {
            "index": "99"
        }
        """
        let jsonData: Data = self.jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        let object = try jsonDecoder.decode(NumberObject.self, from: jsonData)
        
        // Assert
        let actual: Int? = object.index
        let expect: Int = 99
        
        XCTAssertEqual(actual, expect)
    }
}
