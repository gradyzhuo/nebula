//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2021/1/16.
//

import Foundation
import NIO
import NIOExtras

extension DirectAmas: AstralServerDelegatable{
    public final class ServerDelegate: MatterTransferServerDelegate{
        
        public typealias AstralType = DirectAmas

        public let astral: AstralType

        public init(astral: AstralType) {
            self.astral = astral
        }
    }
    
}

extension DirectAmas.ServerDelegate{
    public func server(didBind server: Server) {
        print("direct amas did bind: \(server.channel.localAddress)")
    }
    
//    public func handle(context: ChannelHandlerContext, matter: ActivateMatter) -> Result<ActivateMatter.Reply, Error>? {
//        print("handle matter:", matter)
//        
//        let buffer = context.channel.allocator.buffer(string: "Response")
//        context.writeAndFlush(NIOAny(buffer))
//        return nil
//    }
    
    public func handle(context: ChannelHandlerContext, matter: RegisterMatter) throws -> Result<RegisterMatter.Reply, Error>? {
        print("AMS did register:", matter)
        return nil
    }
}

extension MatterTransferServer where AstralType: Amas{
    public func register(to galalxyName: String) throws {
//        let standardGalaxyClient = Nebula.standard.galaxies[galalxyName]!
        let address = try SocketAddress(ipAddress: "::1", port: 9000)
        let galaxyClient = try StandardGalaxy.client(target: address).delegate(AmasClientDelegate<AstralType>())
        try galaxyClient.register(amas: self.astral)
    }
}
