//
//  DecimalTest.swift
//  JsonDecodeProtectionTests
//
//  Created by Darktt on 2023/10/13.
//

import Foundation
import Testing
@testable
import JsonProtection

struct TestObject: Decodable
{
    @NumberProtection
    var value: Decimal?
}

struct DecimalTest
{
    @Test("小數保護應該正確處理浮點數精度")
    func float0_0001AndRoundDown() throws
    {
        // Arrange
        let jsonString = """
        {
            "value": 122.999999999999999
        }
        """
        
        let jsonData: Data = jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        let object = try jsonDecoder.decode(TestObject.self, from: jsonData)
        let value: Decimal = object.value ?? .zero
        
        // Assert
        let result: String = "\(value)"
        
        #expect(result == "122.999999999999999")
    }
}
