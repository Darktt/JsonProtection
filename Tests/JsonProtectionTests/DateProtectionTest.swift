//
//  DateProtectionTest.swift
//  JsonProtectionTests
//
//  Created by Darktt on 2023/9/8.
//

import Foundation
import Testing
@testable
import JsonProtection

struct DateObject: Decodable
{
    let updateTime: Date?
    
    @DateProtection(configuration: DateConfiguration.self)
    private(set)
    var expiredDate: Date?
}

extension DateObject
{
    struct DateConfiguration: DateConfigurate
    {
        static var option: DateConfigurateOption {
            
            .dateFormat("yyyyMMddhhss", timeZone: TimeZone(abbreviation: "GMT+0800"))
        }
    }
}

struct DateProtectionTest
{
    @Test("日期保護應該使用自定義格式正確解碼日期")
    func dateProtectionSuccess() throws
    {
        // Arrange
        let jsonString = """
        {
            "updateTime": 1694102400,
            "expiredDate": "202309080100"
        }
        """
        let jsonData: Data = jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .secondsSince1970
        
        // Act
        let object = try jsonDecoder.decode(DateObject.self, from: jsonData)
        let updateTime = Date(timeIntervalSince1970: 1694102400.0)
        let expiredDate = Date(timeIntervalSince1970: 1694106000.0)
        
        // Assert
        #expect(object.updateTime == updateTime)
        #expect(object.expiredDate == expiredDate)
    }
}
