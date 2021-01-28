//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2021/1/16.
//

import Foundation
import NIO

extension StandardGalaxy: AstralServerDelegatable{
    public final class ServerDelegate: MatterTransferServerDelegate{
        
        public typealias AstralType = StandardGalaxy
        
        public var astral: AstralType
        
        private let channelsSyncQueue = DispatchQueue(label: "channelsQueue")
        
        public init(astral: AstralType) {
            print("StandardGalaxy Delegate Init")
            self.astral = astral
        }
    }
    
}

extension StandardGalaxy.ServerDelegate{
    public func server(didBind server: Server) {
        print("standardGalaxy did bind: \(String(describing: server.channel.localAddress))")
    }
    
    public func handle(context: ChannelHandlerContext, matter: RegisterMatter) throws -> Result<RegisterMatter.Reply, Error>? {
        self.astral.amases[matter.astralName] = context.channel
        print("RegisterMatter handle matter:", matter)
        return .success(RegisterMatter.Reply(status: "success"))
    }
    
    
    
    
    public func handle(context: ChannelHandlerContext, matter: AskAttributeMatter) throws -> Result<AskAttributeMatter.Reply, Error>? {
        print("ask attribute")
        let c = self.astral.amases.first!.value
        print(c.remoteAddress, context.channel.remoteAddress)
        
        print("here?????????????????")
        let testMatter = ActivateMatter(astral: UUID(), name: "???")
        let matterBytes: [UInt8] = try! testMatter.serialized()
        let buffer = c.allocator.buffer(bytes:  matterBytes)
        c.writeAndFlush(NIOAny(buffer), promise: nil)
        print("write????")
        
        return .success(AskAttributeMatter.Reply(body: .init()))
    }
}


