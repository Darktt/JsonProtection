//
//  DateProtectionTest.swift
//  JsonDecodeProtectionTests
//
//  Created by Eden on 2023/9/8.
//

import XCTest
@testable
import JsonDecodeProtection

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

final class DateProtectionTest: XCTestCase
{
    var jsonString: String!
    
    override func setUpWithError() throws
    {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // Arrange
        
        // Act
        
        // Assert
    }
    
    func testDateProtectionSuccess() throws
    {
        // Arrange
        self.jsonString = """
        {
            "updateTime": 1694102400,
            "expiredDate": "202309080100"
        }
        """
        let jsonData: Data = self.jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .secondsSince1970
        
        // Act
        let object = try jsonDecoder.decode(DateObject.self, from: jsonData)
        let updateTime = Date(timeIntervalSince1970: 1694102400.0)
        let expiredDate = Date(timeIntervalSince1970: 1694106000.0)
        
        // Assert
        XCTAssertEqual(object.updateTime, updateTime)
        XCTAssertEqual(object.expiredDate, expiredDate)
    }
}
