//
//  BoolProtectionTest.swift
//  JsonDecodeProtectionTests
//
//  Created by Darktt on 2022/11/30.
//

import XCTest
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

final class BoolProtectionTest: XCTestCase
{
    var jsonString: String!
    
    override func setUpWithError() throws
    {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // Arrange
        
        // Act
        
        // Assert
    }
    
    func testBoolProtectionSuccess() throws
    {
        // Arrange
        self.jsonString = """
        {
            "true": true,
            "false": "FALSE"
        }
        """
        let jsonData: Data = self.jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        let object = try jsonDecoder.decode(BoolObject.self, from: jsonData)
        
        // Assert
        XCTAssertTrue(object.true == true)
        XCTAssertTrue(object.false == false)
    }
    
    func testBoolProtectionFailure()
    {
        // Arrange
        self.jsonString = """
        {
            "true": 4,
            "false": "FALSE"
        }
        """
        let jsonData: Data = self.jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        XCTAssertThrowsError(try jsonDecoder.decode(BoolObject.self, from: jsonData)) {
            
            error in
            
            // Assert
            if case let .dataCorrupted(context) = error as? DecodingError {
                
                let actual: String = context.debugDescription
                let expect: String = "Expect `0` or `1` but found `4` instead"
                
                XCTAssertEqual(actual, expect)
            }
        }
    }
}
