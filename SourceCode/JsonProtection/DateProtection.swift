//
//  DateProtection.swift
//
//  Created by Darktt on 2023/9/7.
//  Copyright © 2023 Darktt. All rights reserved.
//

import Foundation

// MARK: - DateConfiguration -

public
protocol DateConfigurate
{
    static
    var option: DateConfigurateOption { get }
}

// MARK: - DateConfigurateOption -

public
enum DateConfigurateOption
{
    /// 時間格式，時區未給的話，即預設系統時區
    case dateFormat(_ format: String, timeZone: TimeZone?)
    
    /// 時間搓（基本單位為秒（Second））
    case secondsSince1970
    
    /// 時間戳（基本單位為毫秒（millisecond））
    case millisecondsSince1970
    
    /// iso8601
    case iso8601(hasFractionalSeconds: Bool)
}

// MARK: - DateProtection -

@propertyWrapper
public
struct DateProtection<Configurate> where Configurate: DateConfigurate
{
    // MARK: - Properties -
    
    public
    var wrappedValue: Date?
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    public
    init(configuration: Configurate.Type) { }
}

// MARK: - Conform Protocols -

extension DateProtection: Decodable
{
    public
    init(from decoder: Decoder) throws
    {
        let container: SingleValueDecodingContainer = try decoder.singleValueContainer()
        
        if let stringValue = try? container.decode(String.self) {
            
            let date: Date? = self.date(from: stringValue)
            
            self.wrappedValue = date
            return
        }
        
        if let integerValue = try? container.decode(Int.self) {
            
            let date: Date? = self.date(from: integerValue)
            
            self.wrappedValue = date
            
            return
        }
        
        if let doubleValue = try? container.decode(Double.self) {
            
            let date: Date? = self.date(from: doubleValue)
            
            self.wrappedValue = date
            
            return
        }
        
        self.wrappedValue = nil
    }
}

// MARK: - Private Methods -

private
extension DateProtection
{
    func date(from string: String) -> Date?
    {
        var date: Date? = nil
        let option: DateConfigurateOption = Configurate.option
        
        if case let .dateFormat(format, timeZone: timeZone) = option {
            
            let formatter = DateFormatter.privateShare
            formatter.dateFormat = format
            formatter.timeZone = timeZone ?? .current
            
            date = formatter.date(from: string)
        }
        
        if case .secondsSince1970 = option,
           let timeInterval = TimeInterval(string) {
            
            date = Date(timeIntervalSince1970: timeInterval)
        }
        
        if case .millisecondsSince1970 = option,
           var timeInterval = TimeInterval(string) {
            
            timeInterval /= 1000.0
            
            date = Date(timeIntervalSince1970: timeInterval)
        }
        
        if case let .iso8601(hasFractionalSeconds) = option {
            
            let options: ISO8601DateFormatter.Options = hasFractionalSeconds ? .withFractionalSeconds : []
            
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = options
            
            date = formatter.date(from: string)
        }
        
        return date
    }
    
    func date(from integer: Int) -> Date?
    {
        var date: Date?
        let option: DateConfigurateOption = Configurate.option
        
        if case let .dateFormat(format, timeZone) = option {
            
            let formatter = DateFormatter.privateShare
            formatter.dateFormat = format
            formatter.timeZone = timeZone ?? .current
            
            date = formatter.date(from: String(integer))
        }
        
        if case .secondsSince1970 = option {
            
            let timeInterval = TimeInterval(integer)
            
            date = Date(timeIntervalSince1970: timeInterval)
        }
        
        if case .millisecondsSince1970 = option {
            
            let timeInterval = TimeInterval(integer) / 1000.0
            
            date = Date(timeIntervalSince1970: timeInterval)
        }
        
        if case let .iso8601(hasFractionalSeconds) = option {
            
            let options: ISO8601DateFormatter.Options = hasFractionalSeconds ? .withFractionalSeconds : []
            
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = options
            
            date = formatter.date(from: String(integer))
        }
        
        return date
    }
    
    func date(from double: Double) -> Date?
    {
        var date: Date?
        let option: DateConfigurateOption = Configurate.option
        
        if case let .dateFormat(format, timeZone) = option {
            
            let formatter = DateFormatter.privateShare
            formatter.dateFormat = format
            formatter.timeZone = timeZone ?? .current
            
            date = formatter.date(from: String(double))
        }
        
        if case .secondsSince1970 = option {
            
            date = Date(timeIntervalSince1970: double)
        }
        
        if case .millisecondsSince1970 = option {
            
            let timeInterval = double / 1000.0
            
            date = Date(timeIntervalSince1970: timeInterval)
        }
        
        if case let .iso8601(hasFractionalSeconds) = option {
            
            let options: ISO8601DateFormatter.Options = hasFractionalSeconds ? .withFractionalSeconds : []
            
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = options
            
            date = formatter.date(from: String(double))
        }
        
        return date
    }
}

// MARK: - Private Extension -

fileprivate
extension DateFormatter
{
    static let privateShare: DateFormatter = .init()
}
