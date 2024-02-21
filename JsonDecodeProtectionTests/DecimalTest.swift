//
//  DecimalTest.swift
//  JsonDecodeProtectionTests
//
//  Created by Darktt on 2023/10/13.
//

import XCTest
@testable
import JsonDecodeProtection

struct TestObject: Decodable
{
    @NumberProtection
    var value: Decimal?
}

final class DecimalTest: XCTestCase 
{
    var jsonString: String!
    
    var formatter: NumberFormatter = NumberFormatter()
    
    override func setUpWithError() throws
    {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // Arrange
        
        // Act
        
        // Assert
    }
    
    func testFloat0_0001AndRoundDown() throws
    {
        self.jsonString = """
        {
            "value": 122.999999999999999
        }
        """
        
        let jsonData: Data = self.jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        let object = try jsonDecoder.decode(TestObject.self, from: jsonData)
        let valueNumber = NSDecimalNumber(decimal: object.value ?? .zero)
        self.formatter.minimumFractionDigits = 3
        self.formatter.maximumFractionDigits = 9
        self.formatter.roundingMode = .down
        
        // Assert
        let result: String = self.formatter.string(from: valueNumber)!
        
        XCTAssertTrue(result == "122.999999999")
    }
}
