//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2021/1/25.
//

import Foundation
import NIO
import AnyCodable


//public struct InvokedResult<Encoder: Swift.Encoder, Decoder: Swift.Decoder>{
//    lazy let encoder = {
//        return Encoder()
//    }()
//    lazy let decoder = {
//        return Decoder()
//    }()
//
//    var value: Data
//
//    public static func wrap(value: Codable)->Self{
//        Self
//        return ""
//    }
//
//}

@dynamicCallable
public protocol Invocable{
    func invoke(arguments: [Argument]) throws -> ReturnWrapper
}

extension Invocable{
    public func dynamicallyCall(withKeywordArguments args: RawArguments)->ReturnWrapper{
        return try! self.invoke(arguments: args.represented())
    }
}

//public struct Invocation: Invocable{
//    public internal(set) var method: Method
//    public internal(set) var arguments: [Argument] = []
//
//    internal init(method: Method, arguments: [Argument]) {
//        self.method = method
//        self.arguments = arguments
//    }
//
//    public init(method: Method, arguments: RawArguments) throws {
//        self.init(method: method, arguments: try Argument.arguments(with: arguments))
//    }
//
//    public func invoke() throws -> Codable? {
//        let argumentsDict = try arguments.represented()
//        return self.method.action(argumentsDict)
//    }
//}

public struct AstralInvoker<AstralType: CallableAstral>:Invocable{
    
    internal var client: MatterTransferClient<AstralType>
    public private(set) var method: String
    public private(set) var service: String
    
    public init(client: MatterTransferClient<AstralType>, service: String, method: String) throws {
        self.client = client
        self.method = method
        self.service = service
    }
    
    public func invoke(arguments: [Argument]) throws -> ReturnWrapper {
        let buffer = try self.client.call(service: service, method: method, arguments: arguments)
        let bytes = buffer.getBytes(at: buffer.readerIndex, length: buffer.readableBytes) ?? []
        let data = Data(bytes)
        return ReturnWrapper(data: data)
//        let decoder = JSONDecoder()
//        return try decoder.decode(AnyCodable.self, from: data)
    }
    
//    public func invoke(arguments: RawArguments) throws -> Codable?{
//        let buffer = try self.client.call(service: service, method: method, argumentsDict: arguments)
//        print(String(buffer: buffer))
//        let bytes = buffer.getBytes(at: buffer.readerIndex, length: buffer.readableBytes) ?? []
//        let data = Data(bytes)
//        let decoder = JSONDecoder()
//        return try decoder.decode(AnyCodable.self, from: data)
//    }
}
