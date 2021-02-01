//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2021/1/23.
//

import Foundation
import AnyCodable

//public protocol NebulaEncodable: Any, Encodable{}
//public protocol NebulaDecodable: Any, Decodable{}
//public typealias NebulaCodable = NebulaEncodable & NebulaDecodable
//public struct AnyCodable: Codable {}

public typealias RawArguments = KeyValuePairs<String, AnyCodable>
//public struct Argument{
//    public struct Rule{
//
//        internal let valueType: ValueType
//        public internal(set) var key: String
//
//        public func make(withValue value: Codable)->Argument?{
//            guard self.valueType == ValueType.by(value) else{
//                return nil
//            }
//            return Argument(rule: self, value: value)
//        }
//
//        internal init(valueType: ValueType, key: String) {
//            self.valueType = valueType
//            self.key = key
//        }
//
//    }
//    internal let rule: Rule
//    public var value: Codable
//
//    public static func rule(byKey key: String, as valueType: ValueType)->Rule{
//        return .init(valueType: valueType, key: key)
//    }
//
//    public static func arguments(with values: RawArguments) throws ->[Self]{
//        return try values.map{
//            guard let valueType = ValueType.by($0.value) else {
//                throw NebulaError.fail(message: "ValueType can't made by value.")
//            }
//            let rule = Self.rule(byKey: $0.key, as: valueType)
//            return rule.make(withValue: $0.value)!
//        }
//    }
//
//    internal init(rule: Rule, value: Codable) {
//        self.rule = rule
//        self.value = value
//    }
//}


//extension Array where Element == Argument{
//    public func represented() throws ->RawArguments {
//        return  RawArguments(dictionaryLiteral: self.compactMap { ($0.rule.key, $0.value) })
////        return RawArguments(uniqueKeysWithValues: )
//    }
//    
//    public static func make(by raw: RawArguments)->Self?{
//        return try? Argument.arguments(with: raw)
//    }
//}
//public protocol Argument{
//    var key: String { get }
//
//    func unwrap<T: Decodable>(to type: T.Type) throws ->T
//}

extension KeyValuePairs where Key == String, Value == AnyCodable{
    public func represented() throws ->[Argument]{
        let arguments:[Argument] = try self.compactMap {
            return try Argument.wrap(key: $0.key, value: $0.value)
        }
        return arguments
    }
}

public struct Argument{
    public internal(set) var key: String
    public internal(set) var data: Data
    
//    internal static func wrap(key: String, value: Any, valueType: Value.Type) throws ->Self{
//        let encodableValue = value as! Value
//        let encoder = JSONEncoder()
//        let data = try encoder.encode(encodableValue)
//        return .init(key: key, data: data)
//    }
    
    public static func wrap(key: String, value: AnyCodable) throws ->Self{
        let encodableValue = value
        let encoder = JSONEncoder()
        let data = try encoder.encode(encodableValue)
        return .init(key: key, data: data)
//        return try .wrap(key: key, value: value, valueType: Value.self)
    }
    
    public static func arguments(with values: RawArguments) throws ->[Argument]{
        return try values.represented()
    }
    
    internal init(key: String, data: Data) {
        self.key = key
        self.data = data
    }
    
    public func unwrap() throws -> AnyCodable{
        let decoder = JSONDecoder()
        return try decoder.decode(AnyCodable.self, from: self.data)
    }
    
    
}

extension Array where Element == Argument{
    public func toDictionary()->[String: Any?]{
        return Dictionary(uniqueKeysWithValues: self.map{ ($0.key, try? $0.unwrap().value) })
    }
}

extension Argument{
//    public encode(by encoder: Encoder)->Data{
//        return
//    }
//    internal enum CodingKeys: String, CodingKey{
//        case key = "key"
//        case value = "value"
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: Self.CodingKeys)
//        try container.encode(self.key, forKey: .key)
//        switch self.value {
//        case let encodableValue as Encodable:
//            try container.encode(encodableValue, forKey: .value)
//        default:
//
//        }
//
//    }
}

