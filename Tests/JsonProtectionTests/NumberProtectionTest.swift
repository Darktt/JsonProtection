//
//  NumberProtectionTest.swift
//  JsonDecodeProtectionTests
//
//  Created by Darktt on 2022/12/7.
//

import XCTest
@testable
import JsonProtection

struct NumberObject: Decodable
{
    @NumberProtection
    private(set)
    var index: Int?
    
    @NumberProtection
    private(set)
    var profit: Decimal?
    
    @NumberProtection
    private(set)
    var amount: Int?
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
    
    func testNumberProtectionSuccessForDecimalType() throws
    {
        // Arrange
        self.jsonString = """
        {
            "profit": "0.04"
        }
        """
        let jsonData: Data = self.jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        let object = try jsonDecoder.decode(NumberObject.self, from: jsonData)
        
        // Assert
        let actual: Decimal? = object.profit
        let expect: Decimal = 0.04
        
        XCTAssertEqual(actual, expect)
    }
    
    func testNumberProtectionSuccessForFractionString() throws
    {
        // Arrange
        self.jsonString = """
        {
            "amount": "122.999999999999999"
        }
        """
        let jsonData: Data = self.jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        let object = try jsonDecoder.decode(NumberObject.self, from: jsonData)
        
        // Assert
        let actual: Int? = object.amount
        let expect: Int = 122
        
        XCTAssertEqual(actual, expect)
    }
}
