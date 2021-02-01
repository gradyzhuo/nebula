//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2021/1/21.
//

import Foundation
//import Combine

import Nebula
import AnyCodable
//import Runtime
//import TensorFlow


let d: KeyValuePairs<String, AnyCodable> = ["a":"b", "c":2]
print(try d.represented())

//func test()->AnyAstral{
//    return StandardGalaxy(name: "xxx")
//}


//struct H<T:Any>{
//    init(type: T){
//
//    }
//}
//let J = valueType.getType()
//func ttt(valueType: ValueType)->H<Any>.Type{
//
//    if J.self == String.self{
//        return type(of: H(type: "String"))
//    }
//    return type(of: H(type: J.self))
//}
//
//print(ttt(valueType: .int))

//func y(a: String, b: String){
//    print("a:", a, "b:", b)
//}
//
//let info = try functionInfo(of: y)
//let tsss = try typeInfo(of: String.self)
//
//print("leee:", info.argumentTypes, tsss.properties)
//
//let x = Mirror(reflecting: y)
////x.subjectType
//print(x.subjectType, type(of: x.subjectType), x.displayStyle, x.superclassMirror, x.children)
//for p in x.children{
//    print(p.label, p.value)
//}
//
//exit(0)

//let rule = Argument.rule(byKey: "words", as: .array(element: .string))
////let rule = Argument.rule(byKey: "words", as: ValueType.array(element: .string))
//let argument = rule.make(withValue: ["a", "b", "c"])
//
//let encoder = JSONEncoder()
//let data = try encoder.encode(argument)
//print("XXX:", argument?.value, data)
//
//let decoder = JSONDecoder()
//let argument2 = try decoder.decode(Argument.self, from: data)
//print(argument2)
//
//let wordVector = ServiceMethod(name: "wordVector", argTypes: [ "words": .collection(collection: .arrayCollection, element: .string) ]){args in
//    return "action return"
//}
//
//print(wordVector.argTypes)
////wordVector.check(with: ["words": ["1", "2", "3"]])
//
//var service = Service(name: "W2V", version: "XX")
//
////service.perform(activity: ServiceMethod(name: "wordVector"), with: ["words": ["1", "2", "3"]])
////print(service.wordVector(with: ["words": ["1", "2", "3"]]))
////print(service.test(with: ["words": ["1", "2", "3"]]))
//service.add(method: wordVector)
//let result = service.wordVector?(with: ["words": ["1", "2", "3"]])
//print("XXX:", result)
//
//
////let arguments:[String:ValueType] = [
////    "test": .string,
////    "yyy": .array(.string)
////]
//
//
////public func test<T>(_ value: T)->ValueType?{
////    switch value {
////    case is String:
////        return .string
////    case is Int:
////        return .int
////    case is Float:
////        return .float
////    case is Double:
////        return .double
////    default:
////        return nil
////    }
////}
//
//
////Dictionary
//let valueType = ValueType.dictionary(element: .int)
//print("???:", valueType.rawValue)
//let r = ValueType(rawValue: valueType.rawValue).map { t -> Bool in
//    print(t, valueType)
//    return t == valueType
//}
//print("!!!:", r)

//@dynamicCallable
//struct A{
//
//    func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, Any>){
//        print(args)
//    }
//
//}
//
//let a = A()
////a(a: "xx", b: 123)
//
//
//let arguments = KeyValuePairs<String, Codable>(dictionaryLiteral: ("a", 1), ("b", "c"))
