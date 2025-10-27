//
//  BoolProtection.swift
//
//  Created by Darktt on 22/6/9.
//  Copyright © 2022 Darktt. All rights reserved.
//

/**
 Automatic convert to bool value.
*/
@propertyWrapper
public
struct BoolProtection
{
    // MARK: - Properties -
    
    public
    var wrappedValue: Bool?
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    public
    init() { }
}

// MARK: - Conform Protocols -

extension BoolProtection: Decodable
{
    public
    init(from decoder: Decoder) throws
    {
        let container: SingleValueDecodingContainer = try decoder.singleValueContainer()
        
        if let boolValue = try? container.decode(Bool.self) {
            
            self.wrappedValue = boolValue
            return
        }
        
        if let stringValue = try? container.decode(String.self).lowercased() {
            
            switch stringValue {
                
            case "no", "false", "0":
                self.wrappedValue = false
                
            case "yes", "true", "1":
                self.wrappedValue = true
                
            default:
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Expect true/false, yes/no or 1/0 but`\(stringValue)` instead")
            }
            return
        }
        
        if let integerValue = try? container.decode(Int.self) {
            
            switch integerValue {
                
            case 0:
                self.wrappedValue = false
                
            case 1:
                self.wrappedValue = true
                
            default:
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Expect `0` or `1` but found `\(integerValue)` instead")
            }
            
            return
        }
        
        self.wrappedValue = nil
    }
}

extension BoolProtection: CustomStringConvertible
{
    public
    var description: String
    {
        self.wrappedValue.map {
            
            "\($0)"
        } ?? "nil"
    }
}
