//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2021/1/22.
//

import Foundation
//import AnyCodable

public typealias MethodAction = (_ args: [Argument]) throws -> ReturnWrapper

public protocol Method{
    var name: String { get }
    var action: MethodAction { get }
}

public struct ServiceMethod: Method, Invocable{
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
    
    public func invoke(arguments args: RawArguments) throws -> ReturnWrapper {
        return try self.invoke(arguments: args.represented())
    }
    
    public func invoke(arguments args: [Argument]) throws -> ReturnWrapper {
        return try self.action(args)
    }

}
