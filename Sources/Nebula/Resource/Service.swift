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
    public internal(set) var methods: [String : Method & Invocable] = [:]
    
    public init(name: String, version: String? = nil) {
        self.name = name
        self.version = version
    }
    
    //method name is same as service name
    public convenience init(name: String, version: String? = nil, action: @escaping MethodAction) {
        self.init(name: name, version: version)
        self.add(method: ServiceMethod(name: name, action: action))
    }
    
    public subscript(dynamicMember member: String)->Invocable {
        let defaultMethod = ServiceMethod(name: "NOTSET"){ _ in
            return ReturnWrapper(data: nil)
        }
        return self.methods[member, default: defaultMethod]
    }
    
//    public func handle(invocation: Invocation) throws -> Codable? {
//        return try invocation.invoke()
//    }
    
//    public subscript(dynamicMember member: String)->MethodAction? {
//        guard let method = self.methods[member] else{
//            return nil
//        }
//        return method.action
//    }
    
}

extension Service{
//    public func callAsFunction(method: String, with args: RawArguments)-> Codable? {
//        return try? self.perform(method: method, with: args)
////        return self.methods[method]?.action(args)
//    }
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
    @discardableResult
    public func add(method: ServiceMethod)->Self{
        self.methods[method.name] = method
        return self
    }
    
    @discardableResult
    public func add(method name: String, argTypes: [String : ValueType]? = nil, action: @escaping MethodAction) rethrows ->Self{
        self.methods[name] = ServiceMethod(name: name, argTypes:argTypes, action: action)
        return self
    }
    
//    public func perform(method name: String, with arguments: RawArguments) throws ->Codable?{
//        let arguments:[String: Any] = Dictionary(uniqueKeysWithValues: arguments.map{ ($0.key, $0.value.value) })
//        return try self.perform(method: name, with: arguments)
//    }
    
    public func perform(method name: String, with arguments: RawArguments) throws ->ReturnWrapper{
//        guard let method = self.methods[name] else {
//            return nil
//        }
//        return method.action(arguments)
        return try self.perform(method: name, with: arguments.represented())
    }
    
    public func perform(method name: String, with arguments: [Argument]) throws ->ReturnWrapper{
//        return try perform(method: name, with: try arguments.represented())
        guard let method = self.methods[name] else {
            return ReturnWrapper(data: nil)
        }
        return try method.invoke(arguments: arguments)
    }
}

@dynamicMemberLookup
public class RPCService: Service{
    
    internal var invoker: (_ method: String)->Invocable
    
    public init(name: String, invoker: @escaping (_ method: String)->Invocable) {
        self.invoker = invoker
        super.init(name: name, version: nil)
    }
    
    public override subscript(dynamicMember member: String)->Invocable {
        return invoker(member)
    }
}
