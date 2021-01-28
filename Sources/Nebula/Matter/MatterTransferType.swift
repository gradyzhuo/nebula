//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2021/1/17.
//

import Foundation
import SwiftProtobuf

public enum MatterActivity:UInt8, CaseIterable{
    case clone        = 0x00
    case ask          = 0x01
    case reply        = 0x02
    case activate     = 0x10
    case register     = 0x12
    case find         = 0x20
    case pair         = 0x21
    case call         = 0x23
    
    internal var bytes:[UInt8]{
        return [self.rawValue]
    }
    
    init<T:ContiguousBytes>(bytes:T) throws{
        let rawValue = bytes.to(type: UInt8.self)
        guard Self.allCases.map({ $0.rawValue }).contains(rawValue) else {
            throw NebulaError.fail(message: "The rawValue from bytes is not a case of MatterActivity.")
        }
        self = Self.init(rawValue: rawValue)!
    }
    
}

public protocol MatterTransferType{
    associatedtype SendBody : Message
    associatedtype ReplyBody : Message
    static var activity: MatterActivity { get }
    static var `default`: Self { get }
    static var reply: Self { get }
    
    func bytes()->[UInt8]
    init?(bytes: [UInt8])
}

extension MatterTransferType where Self:RawRepresentable, Self.RawValue: FixedWidthInteger&UnsignedInteger {
    public func bytes()->[UInt8]{
        let rawValueBytes = withUnsafeBytes(of: self.rawValue.bigEndian) {
            Array($0)
        }
        return Self.activity.bytes + rawValueBytes
    }
    
    public init?(bytes: [UInt8]) {
        let activityBytes = Array(bytes[0..<Self.activity.bytes.count])
        guard Self.activity.bytes == activityBytes else {
            print("activity is not matched.")
            return nil
        }
        let rawValueBytes = Array(bytes[Self.activity.bytes.count..<bytes.endIndex])
        self.init(rawValue: rawValueBytes.to(type: RawValue.self))
    }
    
}

public enum Clone: UInt8, MatterTransferType{
    public typealias SendBody = Nebula_CloneBody
    public typealias ReplyBody = Nebula_CloneReplyBody
    
    public static var activity: MatterActivity { .clone }
    public static var `default`: Self{
        return .clone
    }
    
    case reply = 0x00
    case clone = 0x01
    case method = 0x02
}

public enum Ask: UInt8, MatterTransferType{
    public typealias SendBody = Nebula_AskAttributeBody
    public typealias ReplyBody = Nebula_AskAttributeReplyBody
    
    public static var activity: MatterActivity { .ask }
    public static var `default`: Self{
        return .attribute
    }
   
    
    
    case reply = 0x00
    case attribute = 0x01
}

public enum Activate: UInt8, MatterTransferType{
    public typealias SendBody = Nebula_ActivateBody
    public typealias ReplyBody = Nebula_ReplyBody
    
    public static var activity: MatterActivity { .activate }
    public static var `default`: Self{
        return .activate
    }
    
    case reply = 0x00
    case activate = 0x01
    case deactivate = 0x02
}

public enum Register: UInt8, MatterTransferType{
    public typealias SendBody = Nebula_RegisterBody
    public typealias ReplyBody = Nebula_RegisterReplyBody
    
    public static var activity: MatterActivity { .register }
    public static var `default`: Self{
        return .register
    }
    
    case reply = 0x00
    case register = 0x01
    case unregister = 0x02
    
}


public enum Find: UInt8, MatterTransferType{
    public typealias SendBody = Nebula_FindBody
    public typealias ReplyBody = Nebula_ReplyBody
    
    public static var activity: MatterActivity { .find }
    public static var `default`: Self{
        return .galaxy
    }
    
    
    case reply = 0x00
    case galaxy    = 0x01
    case amas      = 0x02
    case stellaire = 0x03
}

public enum Pair: UInt8, MatterTransferType{
    public typealias SendBody = Nebula_PairBody
    public typealias ReplyBody = Nebula_PairBody
    
    public static var activity: MatterActivity { .pair }
    public static var `default`: Self{
        return .stellaire
    }
    
    case reply = 0x00
    case stellaire = 0x01
}

public enum Call: UInt8, MatterTransferType{
    public typealias SendBody = Nebula_CallBody
    public typealias ReplyBody = Nebula_ReplyBody
    
    public static var activity: MatterActivity { .call }
    
    public static var `default`: Self{
        return .service
    }
    
    case reply = 0x00
    case service = 0x01
}
