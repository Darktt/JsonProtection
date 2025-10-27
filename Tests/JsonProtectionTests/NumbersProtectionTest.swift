//
//  NumbersProtectionTest.swift
//  JsonDecodeProtectionTests
//
//  Created by Eden on 2022/12/16.
//

import XCTest
@testable
import JsonProtection

struct NumbersObject: Decodable
{
    @NumbersProtection
    private(set)
    var index: Array<Int>?
}

final class NumbersProtectionTest: XCTestCase
{
    var jsonString: String!
    
    override func setUpWithError() throws
    {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // Arrange
        
        // Act
        
        // Assert
    }
    
    func testNumbersProtectionSuccess() throws
    {
        // Arrange
        self.jsonString = """
        {
            "index": ["10", "20", "50", "100"]
        }
        """
        let jsonData: Data = self.jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        let object = try jsonDecoder.decode(NumbersObject.self, from: jsonData)
        
        // Assert
        let actual: Int? = object.index.map({ $0[2] })
        let expect: Int = 50
        
        XCTAssertEqual(actual, expect)
    }
}
