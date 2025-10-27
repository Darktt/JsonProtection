//
//  NumbersProtectionTest.swift
//  JsonProtectionTests
//
//  Created by Darktt on 2022/12/16.
//

import Foundation
import Testing
@testable
import JsonProtection

struct NumbersObject: Decodable
{
    @NumbersProtection
    private(set)
    var index: Array<Int>?
}

struct NumbersProtectionTest
{
    @Test("數字們保護應該正確解碼字串數字陣列")
    func numbersProtectionSuccess() throws
    {
        // Arrange
        let jsonString = """
        {
            "index": ["10", "20", "50", "100"]
        }
        """
        let jsonData: Data = jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        let object = try jsonDecoder.decode(NumbersObject.self, from: jsonData)
        
        // Assert
        let actual: Int? = object.index.map({ $0[2] })
        let expect: Int = 50
        
        #expect(actual == expect)
    }
}
