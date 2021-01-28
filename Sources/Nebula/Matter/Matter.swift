//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2020/12/19.
//

import Foundation
import SwiftProtobuf

extension ContiguousBytes{
    internal func to<T:UnsignedInteger & FixedWidthInteger>(type: T.Type)->T{
        
        let loaded = self.withUnsafeBytes {
            $0.load(as: T.self)
        }
        return T.init(bigEndian: loaded)
    }
}

extension FixedWidthInteger{
    internal func bytes()->[UInt8]{
        return withUnsafeBytes(of: self.bigEndian) {
            Array($0)
        }
    }
}



public protocol Matter {
    associatedtype MatterType: MatterTransferType
    
    var type: MatterType { get }
    
    func serializedBody() throws -> Data
    
    init(type: MatterType, serializedBody data: Data) throws
}


extension Matter{
    
    public static var activity: MatterActivity {
        return MatterType.activity
    }
    
    public func serialized() throws -> [UInt8] {
        let stamp        = UUID()
        let bodyBytes    = try self.serializedBody().map{ $0 }
        let sizeBytes    = UInt32(bodyBytes.count).bytes()
        let checkCode = UInt16(truncatingIfNeeded: bodyBytes.hashValue).bytes()

        var matterBytes = [UInt8]()
        // type
        matterBytes.append(contentsOf: self.type.bytes())
        // Stamp
        matterBytes.append(contentsOf: stamp.bytes)
        // Check
        matterBytes.append(contentsOf: checkCode)
        // Size
        matterBytes.append(contentsOf: sizeBytes)
        // Body
        matterBytes.append(contentsOf: bodyBytes)
        
        return matterBytes
    }
    
    public func serialized() throws -> Data {
        let bytes:[UInt8] = try self.serialized()
        return Data(bytes)
    }
    
    public init(serializedBytes: [UInt8]) throws {
        let divided = MatterBytesRange.divide(bytes: serializedBytes)
        
        guard serializedBytes.count > 20,
              let type   = MatterType.init(bytes: divided.type) else {
            throw NebulaError.fail(message: "Length of serializedBytes is too short.")
        }
        
        let stamp  = try UUID(bytes: divided.stamp)
//        let kind   = try MatterKind(bytes: divided.kind)
//        let status = divided.status.to(activity: UInt8.self)
//        let check  = divided.check.to(activity: UInt16.self)
        
        let bodyBytes = MatterBytesRange.bodyBytes(bytes: serializedBytes)
        try self.init(type: type, serializedBody: Data(bodyBytes))
    }
}

public protocol ProtoBufMatter: Matter{
    associatedtype Body: Message //where Body == MatterType.SendBody
    var type: MatterType { set get }
    var body:Body { set get }
    
    init(body: Body)
}

extension ProtoBufMatter{
    
    public func serializedBody() throws -> Data{
        return try self.body.serializedData()
    }
    
    public init(type: MatterType, serializedBody data: Data) throws {
        self.init(body: try .init(serializedData: data))
        self.type = type
    }
    
}

//let matter = RequestResponseMatter<Clone, Clone>(serializedBody: Data())
//matter.serialized()
