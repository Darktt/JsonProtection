//
//  MissingKeyProtectionTest.swift
//  JsonDecodeProtectionTests
//
//  Created by Darktt on 2022/12/2.
//

import XCTest
@testable
import JsonDecodeProtection

private
struct MissingKeyObject: Decodable
{
    @MissingKeyProtection
    private(set) var existKey: String?
    
    @MissingKeyProtection
    private(set) var missingKey: String?
}

final class MissingKeyProtectionTest: XCTestCase
{
    var jsonString: String!
    
    override func setUpWithError() throws
    {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // Arrange
        
        // Act
        
        // Assert
    }
    
    func testWithMissingKeySuccess() throws
    {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // Arrange
        self.jsonString = """
        {
            "existKey": "Something"
        }
        """
        let jsonData: Data = self.jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        let object = try jsonDecoder.decode(MissingKeyObject.self, from: jsonData)
        
        // Assert
        XCTAssertTrue(object.existKey == "Something")
        XCTAssertTrue(object.missingKey == nil)
    }
}
