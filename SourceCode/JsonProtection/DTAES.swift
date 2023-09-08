//
//  DTAES.swift
//
//  Created by Darktt on 18/11/9.
//  Copyright © 2018 Darktt. All rights reserved.
//

import CommonCrypto
import Foundation

/// AES 128 encrypt and decrypt
public
class DTAES
{
    // MARK: - Properties -
    
    internal
    var operation: Operation
    
    internal
    var options: Options
    
    internal
    var key: Data = Data()
    
    internal
    var iv: Data?
    
    private
    var contentString: String?
    
    private
    var contentData: Data
    
    private
    var ccOperation: CCOperation {
        
        return CCOperation(self.operation.rawValue)
    }
    
    private
    var ccOptions: CCOptions {
        
        return CCOptions(self.options.rawValue)
    }
    
    // MARK: - Methods -
    // MARK: Initial Method
    
    internal
    convenience init(_ string: String)
    {
        self.init(Data())
        self.contentString = string
    }
    
    internal
    init(_ data: Data)
    {
        self.operation = .encrypt
        self.options = []
        self.contentData = data
    }
    
    internal
    convenience init(_ bytes: UnsafeRawPointer, length: Int)
    {
        let contentData = Data(bytes: bytes, count: length)
        
        self.init(contentData)
    }
    
    // MARK: - internal Methods -
    
    internal
    func setKey(_ keyString: String)
    {
        guard let key: Data = keyString.data(using: .utf8) else {
            
            return
        }
        
        self.key = key
    }
    
    internal
    func setIv(_ ivString: String)
    {
        guard let iv: Data = ivString.data(using: .utf8) else {
            
            return
        }
        
        self.iv = iv
    }
    
    internal
    func result() throws -> String
    {
        let data: Data = try self.result()
        
        var result: String!
        
        if self.operation == .encrypt {
            
            result = data.base64EncodedString()
        }
        
        if self.operation == .decrypt {
            
            result = String(data: data, encoding: .utf8)
        }
        
        return result
    }
    
    internal
    func result() throws -> Data
    {
        if let contentString = self.contentString {
            
            var contentData: Data!
            
            if self.operation == .encrypt {
                
                contentData = contentString.data(using: .utf8)
            }
            
            if self.operation == .decrypt {
                
                contentData = Data(base64Encoded: contentString)
            }
            
            self.contentData = contentData
        }
        
        let key: Array<UInt8> = Array(self.key)
        let length: Int = kCCKeySizeAES128
        var iv: Array<UInt8> = Array(repeating: 0, count: length)
        
        if let _iv = self.iv {
            
            iv = Array(_iv[0 ..< length])
        }
        
        let result: Data = try self.aes(withKey: key, iv: iv)
        
        return result
    }
}

// MARK: - Private Methods -

private
extension DTAES
{
    func aes(withKey key: Array<UInt8>, iv: Array<UInt8>) throws -> Data
    {
        let algorithm = CCAlgorithm(kCCAlgorithmAES)
        var contentData: Data = self.contentData
        let hasZeroPadding: Bool = self.options.contains(.zeroPadding)
        
        if hasZeroPadding && self.operation == .encrypt {
            
            // Reset to ECB mode.
            self.options = [.ecbMode]
            
            // Add zero padding.
            var zeroByte: UInt8 = 0x00
            let blockSize: Int = kCCBlockSizeAES128
            let paddingBytes: Int = blockSize - (contentData.count % blockSize)
            
            (0 ..< paddingBytes).forEach {
                
                _ in
                
                contentData.append(&zeroByte, count: 1)
            }
        }
        
        let bufferSize: Int = contentData.count + kCCBlockSizeAES128
        var buffer: Array<UInt8> = []
        
        var numberBytesCrypto: Int = 0
        
        let cryptStatus: CCCryptorStatus = CCCrypt(self.ccOperation,
                                                   algorithm,
                                                   self.ccOptions,
                                                   key,
                                                   key.count,
                                                   iv,
                                                   contentData._bytes,
                                                   contentData.count,
                                                   &buffer,
                                                   bufferSize,
                                                   &numberBytesCrypto)
        
        if cryptStatus != kCCSuccess {
            
            throw Error.cryptFailed(code: Int(cryptStatus))
        }
        
        let data = Data(bytes: buffer, count: numberBytesCrypto)
        
        return data
    }
}

// MARK: Enumerator, Options, Error

extension DTAES
{
    public
    enum Operation: Int
    {
        case encrypt = 0
        
        case decrypt = 1
    }
    
    public
    struct Options: OptionSet
    {
        public typealias RawValue = UInt8
        
        public static let pkc7Padding: Options = Options(rawValue: 0x0001)
        
        public static let ecbMode: Options = Options(rawValue: 0x0002)
        
        public static let zeroPadding: Options = Options(rawValue: 0x0004)
        
        public let rawValue: UInt8
        
        public init(rawValue: UInt8)
        {
            self.rawValue = rawValue
        }
    }
    
    enum Error: Swift.Error
    {
        case cryptFailed(code: Int)
    }
}

extension DTAES.Error: LocalizedError
{
    internal
    var errorDescription: String?
    {
        return "\(self)"
    }
}

extension DTAES.Error: CustomStringConvertible
{
    internal
    var description: String
    {
        let description: String!
        
        switch self {
                
        case let .cryptFailed(code: code):
            description = "Crypt failed, code: \(code)"
        }
        
        return description
    }
}

// MARK: - Extensions -

private extension Data
{
    // MARK: - Properties -
    
    var _bytes: Array<UInt8> {
        
        return Array<UInt8>(self)
    }
}
