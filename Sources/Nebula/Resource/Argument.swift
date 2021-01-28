//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2021/1/23.
//

import Foundation
import AnyCodable

public struct Argument: Codable{
    public struct Rule: Codable{
        
        internal let valueType: ValueType
        public internal(set) var key: String
        
        public func make(withValue value: Codable)->Argument?{
            guard self.valueType == ValueType.by(value) else{
                return nil
            }
            return Argument(rule: self, value: AnyCodable(value))
        }
        
        internal init(valueType: ValueType, key: String) {
            self.valueType = valueType
            self.key = key
        }
        
    }
    internal let rule: Rule
    public var value: AnyCodable
    
    public static func rule(byKey key: String, as valueType: ValueType)->Rule{
        return .init(valueType: valueType, key: key)
    }
    
    public static func arguments(with values: RawArguments) throws ->[Self]{
        return try values.map{
            guard let valueType = ValueType.by($0.value) else {
                throw NebulaError.fail(message: "ValueType can't made by value.")
            }
            let rule = Self.rule(byKey: $0.key, as: valueType)
            return rule.make(withValue: $0.value)!
        }
    }
    
    internal init(rule: Rule, value: AnyCodable) {
        self.rule = rule
        self.value = value
    }
}


extension Array where Element == Argument{
    public func represented() throws ->RawArguments {
        return RawArguments(uniqueKeysWithValues: self.compactMap { ($0.rule.key, $0.value) })
    }
    
    public static func make(by raw: RawArguments)->Self?{
        return try? Argument.arguments(with: raw)
    }
}
