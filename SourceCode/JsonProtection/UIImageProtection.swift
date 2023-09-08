//
//  UIImageProtection.swift
//
//  Created by Darktt on 2022/7/5.
//  Copyright © 2022 Darktt. All rights reserved.
//

import Foundation
import UIKit.UIImage

@propertyWrapper
public
struct UIImageProtection
{
    // MARK: - Properties -
    
    public
    var wrappedValue: UIImage?
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    public
    init() { }
}

// MARK: - Conform Protocols -

extension UIImageProtection: Decodable
{
    public
    init(from decoder: Decoder) throws
    {
        let container: SingleValueDecodingContainer = try decoder.singleValueContainer()
        let imageName = try container.decode(String.self)
        let image = UIImage(named: imageName)
        
        self.wrappedValue = image
    }
}

extension UIImageProtection: CustomStringConvertible
{
    public var description: String
    {
        self.wrappedValue.map {
            
            "\($0)"
        } ?? "nil"
    }
}
