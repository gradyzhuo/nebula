//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2020/12/25.
//

import Foundation

//public protocol Argument:Codable{
//    associatedtype Value: Codable
//    
//    var key: String { get }
//    var value: Value? { set get }
//}
//
//public struct MethodArgument<Value: Codable>: Argument{
//    public var key: String
//    public var value: Value?
//}
//
////public protocol Method{
////    associatedtype Argument: Argument
////
////}
//
//public struct ServiceMethod{
//    public struct Value {
//        var type: ValueType
//        var value: Any
//        
//        init?(value: Any){
//            guard let type = ValueType.test(value) else {
//                return nil
//            }
//            self.type = type
//            self.value = value
//        }
//    }
//    
//    var name: String
//    var argTypes: [String:ValueType]?
//    var action: (_ args: [String: Codable]) throws ->Codable
//    
////    func check(with args: [String: Codable])->Bool{
////
////        let vs = args.map { key, value in
////            return (key, Value(value: value))
////        }
////        print(Dictionary(uniqueKeysWithValues: vs))
////        return true
////    }
//    
//    public func invoke(with args: [String: Codable]) throws ->Codable?{
//        return try self.action(args)
//    }
//    
//    func callAsFunction(with args: [String: Codable])-> Codable? {
//        return try? self.invoke(with: args)
//    }
//    
//}
//
//
//
//@dynamicMemberLookup
//public struct Service{
//    public var name: String
//    public var version: String
//    public internal(set) var methods: [String : ServiceMethod] = [:]
//    
//    public func handle(activity: ServiceMethod, with arguments: [String : Codable]) -> Codable? {
//        return try? method.invoke(with: arguments)
//    }
//    
//    public subscript(dynamicMember member: String) -> ServiceMethod? {
//        return self.methods[member]
//    }
//}
//
//extension Service{
//    
//    public mutating func add(method: ServiceMethod){
//        self.methods[method.name] = method
//    }
//    
//    public func perform(method name: String, with argument: [String: Codable])->Codable?{
//        guard let method = self.methods[name] else {
//            return nil
//        }
//        return self.handle(method: method, with: argument)
//    }
//}
