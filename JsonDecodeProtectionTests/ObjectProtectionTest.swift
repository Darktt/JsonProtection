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
    private(set)
    var subObjects: Array<SubObject>?
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
            "subObjects": "[{\\"name\\": \\"Jo\\", \\"number\\": 233}, {\\"name\\": \\"Ana\\", \\"number\\": 4565}]"
        }
        """
        let jsonData: Data = self.jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        let object = try jsonDecoder.decode(SomeObject.self, from: jsonData)
        
        // Assert
        XCTAssertEqual(object.subObjects?.count, 2)
        XCTAssertEqual(object.subObjects?.last?.name, "Ana")
    }
    
}
