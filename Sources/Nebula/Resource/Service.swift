//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2021/1/22.
//

import Foundation
import AnyCodable

@dynamicMemberLookup
public class Service{
    public var name: String
    public var version: String?
    public internal(set) var methods: [String : Method] = [:]
    
    public init(name: String, version: String? = nil) {
        self.name = name
        self.version = version
        self.methods = [:]
    }
    
//    public func handle(invocation: Invocation) throws -> Codable? {
//        return try invocation.invoke()
//    }
    
    public subscript(dynamicMember member: String)->MethodAction? {
        guard let method = self.methods[member] else{
            return nil
        }
        return method.action
    }
    
}

extension Service{
    public func callAsFunction(_ method: String, with args: RawArguments)-> Codable? {
        return self.methods[method]?.action(args)
    }
//    public struct Invocation{
//        var method: Method?
//
//        func invoke(with arguments: [String: Codable]) throws ->Codable?{
//            return try self.method?.action(arguments)
//        }
//
//        internal init(method: Method? = nil) {
//            self.method = method
//        }
//
//        public func callAsFunction(with args: [String: Codable])-> Codable? {
//            return try? self.invoke(with: args)
//        }
//    }
//
//    public func invocation(methodName: String)->Invocation{
//        return Invocation(method: self.methods[methodName])
//    }
}

extension Service{
    
    public func add(method: ServiceMethod){
        self.methods[method.name] = method
    }
    
    public func add(method name: String, argTypes: [String : ValueType]? = nil, action: @escaping MethodAction){
        self.methods[name] = ServiceMethod(name: name, argTypes:argTypes, action: action)
    }
    
//    public func perform(method name: String, with arguments: RawArguments) throws ->Codable?{
//        let arguments:[String: Any] = Dictionary(uniqueKeysWithValues: arguments.map{ ($0.key, $0.value.value) })
//        return try self.perform(method: name, with: arguments)
//    }
    
    public func perform(method name: String, with arguments: RawArguments) throws ->Codable?{
        guard let method = self.methods[name] else {
            return nil
        }
        return method.action(arguments)
    }
    
    public func perform(method name: String, with arguments: [Argument]) throws ->Codable?{
        return try perform(method: name, with: try arguments.represented())
    }
}
