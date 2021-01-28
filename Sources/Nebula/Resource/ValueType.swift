//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2021/1/22.
//

import Foundation
import AnyCodable

public indirect enum ValueType: CaseIterable{
    public static var allCases: [ValueType] = [.string, .int, .float, .double, .boolean, .arrayCollection, .dictionaryCollection]
    
    case string
    case int
    case float
    case double
    case boolean
    case arrayCollection
    case dictionaryCollection
    case collection(_ collection: Self, element: Self)
    
    public static func array(element: Self)->Self{
        return .collection(.arrayCollection, element: element)
    }
    
    public static func dictionary(element: Self)->Self{
        return .collection(.dictionaryCollection, element: element)
    }
    
//    internal static func by(_ codableValue: AnyCodable)-> Self?{
//        return Self.by(codableValue.value)
//    }
    
//    internal static func by(_ value: String)->Self?{
//        return .string
//    }
//
//    internal static func by(_ value: Int)->Self?{
//        return .int
//    }
//
//    internal static func by(_ value: Float)->Self?{
//        return .float
//    }
//
//    internal static func by(_ value: Double)->Self?{
//        return .double
//    }
//
//    internal static func by(_ value: Bool)->Self?{
//        return .boolean
//    }
}

extension ValueType{
    public func getType()->Any.Type{
        return String.self
    }
}

extension ValueType{

    internal static func by(_ codableValue: AnyCodable)->Self?{
        return Self.by(codableValue.value)
    }
    
    internal static func by(_ value: Any)->Self?{
        var collectionType: Self?
        var element:Any? = value
        switch value{
        case let v as [Any]:
            collectionType = .arrayCollection
            element = v.first
        case let v as [AnyHashable:Any]:
            collectionType = .dictionaryCollection
            element = v.first?.value
        default:
            collectionType = nil
            element = nil
        }
        
        
        if let collection = collectionType,
           let element = element,
           let subtype = self.by(element){
            return .collection(collection, element: subtype)
        }
        
        switch value {
        case is String:
            return .string
        case is Int:
            return .int
        case is Float:
            return .float
        case is Double:
            return .double
        case is Bool:
            return .boolean
        default:
            return nil
        }
        
    }
    
    
    internal static func getType(rawValue: UInt8)->Self?{
        var collectionType: ValueType?
        
        if rawValue & Self.arrayCollection == Self.arrayCollection{
            collectionType = .arrayCollection
        }else if rawValue & Self.dictionaryCollection == Self.dictionaryCollection{
            collectionType = .dictionaryCollection
        }

        for basicType in Self.allCases.filter({ ![.arrayCollection, .dictionaryCollection].contains($0) }){
            if rawValue & basicType == basicType {
                if let collectionType = collectionType {
                    return .collection(collectionType, element: basicType)
                }else{
                    return basicType
                }
            }
        }
        return nil
    }
}

extension ValueType: RawRepresentable{
    public typealias RawValue = UInt8
    
    public var rawValue: RawValue{
        switch self {
        case .string:
            return 1 << 1
        case .int:
            return 1 << 2
        case .float:
            return 1 << 3
        case .double:
            return 1 << 4
        case .boolean:
            return 1 << 5
        case .arrayCollection:
            return 1 << 6
        case .dictionaryCollection:
            return 1 << 7
        case let .collection(type, subtype):
            return type.rawValue | subtype.rawValue
        
        }
    }
    
    public init?(rawValue: RawValue) {
        if let type = Self.getType(rawValue: rawValue){
            self = type
        }else{
            return nil
        }
        
    }
}

extension ValueType: Equatable{
    public static func ==(lhs: Self, rhs: Self)->Bool{
        return lhs.rawValue == rhs.rawValue
    }
    
    public static func ==(lhs: Self, rhs: RawValue)->Bool{
        return lhs.rawValue == rhs
    }
    
    public static func ==(lhs: RawValue, rhs: Self)->Bool{
        return lhs == rhs.rawValue
    }
    
    public static func &(lhs: RawValue, rhs: Self)->RawValue{
        return lhs & rhs.rawValue
    }
    
    public static func &(lhs: Self, rhs: RawValue)->RawValue{
        return lhs.rawValue & rhs
    }
}

extension ValueType: Codable{
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(self.rawValue)
    }
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let rawValue = try container.decode(Self.RawValue.self)
        guard let type = Self.init(rawValue: rawValue) else {
            throw NebulaError.fail(message: "ValueType did decode failed.")
        }
        self = type
    }
}
