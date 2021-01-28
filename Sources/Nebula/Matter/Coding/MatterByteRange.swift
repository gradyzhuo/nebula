//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2021/1/17.
//

import Foundation

//TODO: - modify to internal static let bytesLength = (activity: 1, status: 1, senderType:2, senderId: 16, check: 4, size: 4)
/**
cols:   | Type  |   Stamp  |    Sender   |  Size  |  Body  |
bytes: |    2     |      20      |     2+16     |     4    |    n      |
Stamp: Astral UUID(16) + Check(4)
*/
internal struct MatterBytesRange{
    internal static let bytesLength = (type: 2, stamp: 16, check: 2, size: 4)
    internal typealias DividedBytes = (type:[UInt8], stamp: [UInt8], check: [UInt8], size:[UInt8])
    
    internal static var type:Range<Int>{
        let startIndex = 0
        let endIndex = startIndex.advanced(by: bytesLength.type)
        return startIndex..<endIndex
    }
    
    internal static var stamp:Range<Int>{
        let startIndex = type.upperBound
        let endIndex = startIndex.advanced(by: bytesLength.stamp)
        return startIndex..<endIndex
    }
    
    internal static var check:Range<Int>{
        let startIndex = stamp.upperBound
        let endIndex = startIndex.advanced(by: bytesLength.check)
        return startIndex..<endIndex
    }
    
    internal static var size:Range<Int>{
        let startIndex = check.upperBound
        let endIndex = startIndex.advanced(by: bytesLength.size)
        return startIndex..<endIndex
    }
    
    internal static func divide(bytes:[UInt8])->DividedBytes{
        let typeBytes = Array(bytes[type])
        let stampBytes  = Array(bytes[stamp])
        let checkBytes  = Array(bytes[check])
        let sizeBytes   = Array(bytes[size])
        return DividedBytes(
            type   : typeBytes,
            stamp  : stampBytes,
            check  : checkBytes,
            size   : sizeBytes
        )
    }
    
    internal static func divide(data: Data)->DividedBytes{
        return Self.divide(bytes: data.map{ $0 })
    }
    
    internal static func bodyBytes(bytes: [UInt8])->[UInt8]{
        let size   = bytes[Self.size].to(type: UInt32.self)
        let bodyRange = MatterBytesRange.size.upperBound..<MatterBytesRange.size.upperBound.advanced(by: Int(size))
        return Array(
            bytes[bodyRange]
        )
    }
    
    internal static func bodyData(data: Data)->Data{
        return Data(Self.bodyBytes(bytes: data.map{ $0 }))
    }
    
}
