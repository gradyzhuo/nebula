//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2021/1/21.
//

import Foundation
import NIO

@dynamicMemberLookup
public protocol Planet: Astral{
    func perform(service: String, method: String, arguments: RawArguments) -> ReturnWrapper?
    func service(service: String) throws -> Service
//    func invoker(method: String) -> Invocable
}

extension Planet{
    public static var category: AstralCategory{
        return .planet
    }
    
//    public func callAsFunction(service: String, method: String, arguments: RawArguments)->Codable?{
//        return self.perform(service:service, method: method, arguments: arguments)
//    }
    
    //service
    public subscript(dynamicMember member: String)->Service {
        return try! service(service: member)
    }
}

public protocol Locatable{
    associatedtype LocatedAstral: Astral
    var located: MatterTransferClient<LocatedAstral> { get }
    init(located: MatterTransferClient<LocatedAstral>)
}

//extension Locatable where LocatedAstral: Stellar{
//
//    public func perform(with arguments: RawArguments)->Codable?{
//        //arguments to  bytes and send to Stellar
////        self.pairedClient?.call(service: <#T##String#>, method: <#T##String#>, argumentsDict: <#T##[String : AnyCodable]#>)
//        return ""
//    }
//}

public class RoguePlanet<LocatedAstral: CallableAstral>: Planet, Locatable{
    
    public var identifier: UUID = UUID()
    public var name: String{
        return self.located.name
    }
    public var namespace: String = ""
    
    public internal(set) var located: MatterTransferClient<LocatedAstral>
    
    public required init(located: MatterTransferClient<LocatedAstral>) {
        self.located = located
    }
    
    public func perform(service: String, method: String, arguments: RawArguments) -> ReturnWrapper?{
        do{
            let invoker = invoker(service: service, method: method)
            return try invoker.invoke(arguments: arguments.represented())
        }catch{
            print(error)
            return nil
        }
    }
    
    public func invoker(service: String, method: String)-> Invocable{
        return try! AstralInvoker(client: self.located, service: service, method: method)
    }
    
    public func service(service: String) throws -> Service{
        return RPCService(name: service) { method in
            return self.invoker(service: service, method: method)
        }
    }
    
}

extension RoguePlanet{
    internal func connect(to address: SocketAddress, eventLoopGroup: EventLoopGroup? = nil) throws {
        self.located = try MatterTransferClient<LocatedAstral>.connect(to: address, eventLoopGroup: eventLoopGroup)
    }
    //test
    public static func locate(to address: SocketAddress) throws ->Self{
        let located = try MatterTransferClient<LocatedAstral>.connect(to: address, eventLoopGroup: nil)
        return Self.init(located: located)
    }
    
//    public static func locate(to namespace: String, address: SocketAddress) throws ->Self{
//        
//    }
}

extension RoguePlanet where LocatedAstral: Stellar{
    
}


