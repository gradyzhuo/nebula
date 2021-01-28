//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2021/1/22.
//

import Foundation
import AnyCodable

public typealias RawArguments = [String:Codable]
public typealias MethodAction = (_ args: RawArguments) ->Codable?

public protocol Method{
    var name: String { get }
    var argTypes: [String:ValueType]? { get }
    var returnType: ValueType? { get }
    var action: MethodAction { get }
}

public struct ServiceMethod: Method{
    public internal(set) var name: String
    public internal(set) var argTypes: [String:ValueType]?
    public internal(set) var returnType: ValueType?
    public internal(set) var action: MethodAction
    
//    func check(with args: [String: Codable])->Bool{
//
//        let vs = args.map { key, value in
//            return (key, Value(value: value))
//        }
//        print(Dictionary(uniqueKeysWithValues: vs))
//        return true
//    }
    
    public init(name: String, argTypes: [String : ValueType]? = nil, returnType: ValueType? = nil, action: @escaping MethodAction) {
        self.name = name
        self.argTypes = argTypes
        self.returnType = returnType
        self.action = action
    }
    
    public func invoke(with args: RawArguments) throws -> Codable? {
        return self.action(args)
    }

}


