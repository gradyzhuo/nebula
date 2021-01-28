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
    func perform(method: String, arguments: RawArguments) -> Codable?
    func invoker(method: String) -> Invocable
}

extension Planet{
    public static var category: AstralCategory{
        return .planet
    }
    
    public func callAsFunction(method: String, arguments: RawArguments)->Codable?{
        return self.perform(method: method, arguments: arguments)
    }
    
    public subscript(dynamicMember member: String)->Invocable {
        return invoker(method: member)
    }
}

public protocol Locatable{
    associatedtype LocatedAstral: Astral
    var located: MatterTransferClient<LocatedAstral>? { get }
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
    public var name: String = ""
    public var namespace: String = ""
    
    public internal(set) var located: MatterTransferClient<LocatedAstral>?
    
    internal init() {
    }
    
    public func perform(method: String, arguments: RawArguments) -> Codable?{
        do{
            let invoker = self.invoker(method: method)
            return try invoker.invoke(arguments: arguments)
        }catch{
            print(error)
            return nil
        }
    }
    
    public func invoker(method: String) -> Invocable{
        return try! AstralInvoker(client: self.located!, service: self.located!.name, method: method)
    }
    
}

extension RoguePlanet{
    internal func connect(to address: SocketAddress, eventLoopGroup: EventLoopGroup? = nil) throws {
//        self.located = try MatterTransferClient<LocatedAstral>.connect(to: address, eventLoopGroup: eventLoopGroup)
    }
}

extension RoguePlanet where LocatedAstral: Stellar{
    
}


