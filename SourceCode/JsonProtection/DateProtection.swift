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
    static var dateFormat: String { get }
    
    static var timeZone: TimeZone { get }
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
        let formatter = DateFormatter.privateShare
        formatter.dateFormat = Configurate.dateFormat
        formatter.timeZone = Configurate.timeZone
        let container: SingleValueDecodingContainer = try decoder.singleValueContainer()
        
        if let stringValue = try? container.decode(String.self) {
            
            let date: Date? = formatter.date(from: stringValue)
            
            self.wrappedValue = date
            return
        }
        
        if let integerValue = try? container.decode(Int.self) {
            
            let stringValue = String(integerValue)
            let date: Date? = formatter.date(from: stringValue)
            
            self.wrappedValue = date
            
            return
        }
        
        if let doubleValue = try? container.decode(Double.self) {
            
            let stringValue = String(doubleValue)
            let date: Date? = formatter.date(from: stringValue)
            
            self.wrappedValue = date
            
            return
        }
        
        self.wrappedValue = nil
    }
}

// MARK: - Private Extension -

fileprivate
extension DateFormatter
{
    static let privateShare: DateFormatter = .init()
}
