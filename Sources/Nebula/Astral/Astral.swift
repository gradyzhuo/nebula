//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2020/12/19.
//

import Foundation
import NIO
import AnyCodable

public typealias NebulaAstralTypeName = String
public let NEBULA_ANY_NAME:NebulaAstralTypeName = "Any"
public let NEBULA_PLANET_NAME:NebulaAstralTypeName = "Planet"
public let NEBULA_STELLAIRE_NAME:NebulaAstralTypeName = "Stellar"
public let NEBULA_AMAS_NAME:NebulaAstralTypeName = "Amas"
public let NEBULA_GALAXY_NAME:NebulaAstralTypeName = "Galaxy"

public enum AstralCategory:UInt16{
    case any       = 0
    case planet    = 1
    case stellaire = 2
    case amas      = 4
    case galaxy    = 8
    
    public var name:NebulaAstralTypeName {
        switch self {
        case .any:
            return NEBULA_ANY_NAME
        case .planet:
            return NEBULA_PLANET_NAME
        case .stellaire:
            return NEBULA_STELLAIRE_NAME
        case .amas:
            return NEBULA_AMAS_NAME
        case .galaxy:
            return NEBULA_GALAXY_NAME
        }
    }
    
    public var prefix: String{
        return "\(name):"
    }
    
    public init?(name: NebulaAstralTypeName){
        switch name {
        case NEBULA_ANY_NAME:
            self = .any
        case NEBULA_PLANET_NAME:
            self = .planet
        case NEBULA_STELLAIRE_NAME:
            self = .stellaire
        case NEBULA_AMAS_NAME:
            self = .amas
        case NEBULA_GALAXY_NAME:
            self = .galaxy
        default:
            return nil
        }
    }
}

public typealias NameSpace = String

public struct AstralID{
    var identifier: UUID {
        return UUID()
    }
    var name: String {
        return ""
    }
}

public protocol Astral {
    static var category: AstralCategory { get }
    var identifier: UUID { get }
    var name: String { get }
}

public protocol CallableAstral:Astral{
    
}

extension MatterTransferClient where AstralType: CallableAstral{
    public func call(service: String, method: String, argumentsDict: RawArguments) throws -> ByteBuffer{
        let arguments = try Argument.arguments(with: argumentsDict)
        let matter = CallMatter(service: service, method: method, arguments: arguments)
        let buffer = try self.request(matter: matter)
        print(buffer)
        return buffer
    }
}

public protocol AstralServerDelegatable{
    associatedtype ServerDelegate: MatterTransferServerDelegate where ServerDelegate.AstralType == Self
}

extension MatterTransferServerDelegate{
    public func handle(context: ChannelHandlerContext, matter: CloneMatter) throws -> Result<CloneMatter.Reply, Error>? {
        return .success(CloneMatter.Reply(astral: self.astral))
    }
}

extension AstralServerDelegatable {
    internal var serverDelegate: ServerDelegate{
        return ServerDelegate(astral: self)
    }
}

//public protocol AstralClientDelegatable{
//    associatedtype ClientDelegate: MatterTransferClientDelegate
//}

//extension AstralClientDelegatable {
//    internal static var clientDelegate: ClientDelegate{
//        return ClientDelegate()
//    }
//}

//MARK: - AstralClientDelegatable

extension Astral{
    
    public static func client(target: SocketAddress, eventLoopGroup: EventLoopGroup? = nil) throws -> MatterTransferClient<Self>{
        return try MatterTransferClient<Self>.connect(to: target, eventLoopGroup: eventLoopGroup)
    }
}

//MARK: - AstralServerDelegatable

extension Astral where Self : AstralServerDelegatable{
//    public static func server(target address: SocketAddress, name: String, identifier: UUID = UUID(), eventLoopGroup: EventLoopGroup? = nil) throws -> MatterTransferServer<Self>{
//        return try MatterTransferServer.bind(on: address, with: Self.init(name: name, identifier: identifier))
//    }
    
//    public static func listen(on ipAddress: String, port: Int, name: String, identifier: UUID = UUID(), eventLoopGroup: EventLoopGroup? = nil){
//        do{
//            let address = try SocketAddress(ipAddress: ipAddress, port: port)
//            try Self.server(target: address, name: name, identifier: identifier, eventLoopGroup: eventLoopGroup)
//                .channel
//                .closeFuture
//                .wait()
//        }catch{
//            print("listen failed.")
//        }
//        
//    }
}

//public protocol NMTAstralServer: ServerDelegate, MatterHandleable{
//    associatedtype AstralClass: ServerAstral
//
//    var astral: AstralClass { get }
//    var address: SocketAddress { get }
//
//    init(address: SocketAddress, astral: AstralClass)
//}
//
//extension NMTAstralServer{
//    public func bind(eventLoopGroup: EventLoopGroup? = nil) throws -> NebulaServer{
//        let config = NMTConfiguration(address: self.address, eventLoopGroup: eventLoopGroup)
//        return try NMTStandardServer.bind(configuration: config, delegates: [self])
//    }
//}
//
//public protocol ServerAstral: Astral{
//    associatedtype Server: NMTAstralServer
////    var address: SocketAddress { set get }
////    init(address: SocketAddress, name: String, identifier: UUID)
//}
//
//extension ServerAstral{
//    public static func server(address: SocketAddress, name: String, identifier: UUID)->Server{
//        let astral = Self.Server.AstralClass.init(name: name, identifier: identifier)
//        return Self.Server.init(address: address, astral: astral)
//    }
//
//}
//
//public protocol ClientAstral:Astral{
//    var client: Client? { get }
//    init(client: Client)
//
//    func activate()
//    func deactivate()
//}
//
//
//extension ServerAstral {
//    //TODO: - Stub, need implement.
//    public var isActivated: Bool { true }
//
//}


//extension ClientAstral {
//    public static func connect(to address: SocketAddress, eventLoopGroup: EventLoopGroup? = nil) throws -> Self{
//        let config = NMTConfiguration(address: address, eventLoopGroup: eventLoopGroup)
//        
////        AstralClient.connect(to: <#T##SocketAddress#>, astral: <#T##_#>, eventLoopGroup: <#T##EventLoopGroup#>)
//        let client = try NMTStandardClient.connect(configuration: config, delegates: [])
//        let astral = Self.init(client: client)
//        return astral
//    }
//    
//    public static func connect(to ip: String, port: Int, eventLoopGroup: EventLoopGroup? = nil) throws -> Self{
//        let address = try SocketAddress(ipAddress: ip, port: port)
//        return try self.connect(to: address, eventLoopGroup: eventLoopGroup)
//    }
//    
//    
//    public static func client(to address: SocketAddress, eventLoopGroup: EventLoopGroup? = nil) throws -> AstralClient<Self>{
//        let config = NMTConfiguration(address: address, eventLoopGroup: eventLoopGroup)
//
//        let client = try NMTStandardClient.connect(configuration: config, delegates: [])
//        let astral = Self.init(name: "", identifier: UUID())
//        return AstralClient(astral: astral, underlying: client)
//    }
//}

