//
//  NumberProtectionTest.swift
//  JsonDecodeProtectionTests
//
//  Created by Darktt on 2022/12/7.
//

import Foundation
import Testing
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

struct NumberProtectionTest
{
    @Test("數字保護應該成功解碼字串數字")
    func numberProtectionSuccess() throws
    {
        // Arrange
        let jsonString = """
        {
            "index": "99"
        }
        """
        let jsonData: Data = jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        let object = try jsonDecoder.decode(NumberObject.self, from: jsonData)
        
        // Assert
        let actual: Int? = object.index
        let expect: Int = 99
        
        #expect(actual == expect)
    }
    
    @Test("數字保護應該成功解碼 Decimal 類型")
    func numberProtectionSuccessForDecimalType() throws
    {
        // Arrange
        let jsonString = """
        {
            "profit": "0.04"
        }
        """
        let jsonData: Data = jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        let object = try jsonDecoder.decode(NumberObject.self, from: jsonData)
        
        // Assert
        let actual: Decimal? = object.profit
        let expect: Decimal = 0.04
        
        #expect(actual == expect)
    }
    
    @Test("數字保護應該成功處理小數字串")
    func numberProtectionSuccessForFractionString() throws
    {
        // Arrange
        let jsonString = """
        {
            "amount": "122.999999999999999"
        }
        """
        let jsonData: Data = jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        
        // Act
        let object = try jsonDecoder.decode(NumberObject.self, from: jsonData)
        
        // Assert
        let actual: Int? = object.amount
        let expect: Int = 122
        
        #expect(actual == expect)
    }
}
