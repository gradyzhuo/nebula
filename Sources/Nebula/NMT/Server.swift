//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2020/12/20.
//

import Foundation
import NIO


public protocol Server {
    var address: SocketAddress { get }
    var channel: Channel { get }
}

extension Server {

    public func stop() throws {
        try self.channel.close().wait()
        try self.channel.eventLoop.syncShutdownGracefully()
    }
    
    public func listen() throws {
        try self.channel.closeFuture.wait()
    }
    
    public var closeFuture: EventLoopFuture<Void>{
        return self.channel.closeFuture
    }
    
}


public final class MatterTransferServer<AstralType: AstralServerDelegatable>: Server, MatterTransferProtocol{
    public let address: SocketAddress
    public var channel: Channel
    public let astral: AstralType
    
    internal init(address: SocketAddress, astral: AstralType, channel: Channel){
        self.address = address
        self.astral = astral
        self.channel = channel
    }
}

extension MatterTransferServer{
    
    internal static func bootstrap(eventLoopGroup:EventLoopGroup? = nil) -> ServerBootstrap{
        let eventLoopGroup = eventLoopGroup ?? MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        let bootstrap = ServerBootstrap(group: eventLoopGroup).serverChannelOption(ChannelOptions.backlog, value: 256)
            .serverChannelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
            .childChannelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
            .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 16)
            .childChannelOption(ChannelOptions.recvAllocator, value: AdaptiveRecvByteBufferAllocator())
        return bootstrap
    }
    
    public static func bind(on address: SocketAddress, with astral: AstralType, eventLoopGroup: EventLoopGroup? = nil) throws -> Self {
        let mainHandler = NMTServerInboundHandler(delegates: astral.serverDelegate)
        let channelFuture = Self.bootstrap(eventLoopGroup: eventLoopGroup)
            // Set the handlers that are applied to the accepted Channels
            .childChannelInitializer{
                $0.pipeline.addHandler(mainHandler, name: "main")
            }
            .bind(to: address)
            
        let channel = try channelFuture.wait()
        guard let localAddress = channel.localAddress else {
            fatalError("Address was unable to bind. Please check that the socket was not closed or that the address family was understood.")
        }
        print("Server started and listening on \(localAddress)")
        let server = Self.init(address: address, astral: astral, channel: channel)
        mainHandler.server(didBind: server)
        return server
    }
}

extension MatterTransferServer{
    public struct Builder{
        var astral: AstralType
        var address: SocketAddress
        var eventLoopGroup: EventLoopGroup
    }
    
    public static func build(with astral: AstralType, address: SocketAddress, eventLoopGroup: EventLoopGroup? = nil)->Builder{
        let eventLoopGroup = eventLoopGroup ?? MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        return Builder(astral: astral, address:address, eventLoopGroup: eventLoopGroup)
    }
}

extension MatterTransferServer.Builder{
    public func bind() throws ->MatterTransferServer<AstralType>{
        return try MatterTransferServer.bind(on: self.address, with: self.astral, eventLoopGroup: self.eventLoopGroup)
    }
}
//
//public final class NMTStandardServer: _Server, Server{
//
//    public typealias ServerChannel = Channel
//
//    public private(set) var channel: Channel
//    public private(set) var configuration: NMTConfiguration
//
//    public var address: SocketAddress {
//        return configuration.address
//    }
//
//    internal init(configuration:NMTConfiguration, channel:ServerChannel) {
//        self.configuration = configuration
//        self.channel = channel
//    }
//
//    deinit {
//        try! self.stop()
//    }
//}
//
//extension NMTStandardServer{
//
//    internal static func bootstrap(eventLoopGroup:EventLoopGroup) -> ServerBootstrap{
//        let bootstrap = ServerBootstrap(group: eventLoopGroup).serverChannelOption(ChannelOptions.backlog, value: 256)
//            .serverChannelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
//            .childChannelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
//            .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 16)
//            .childChannelOption(ChannelOptions.recvAllocator, value: AdaptiveRecvByteBufferAllocator())
//        return bootstrap
//    }
//
//    public static func bind(configuration: NMTConfiguration, delegates: [ServerDelegate]) throws -> Self {
//        let mainHandler = ServerChannelInboundHandler(delegates: delegates)
//        let channel = try Self.bootstrap(eventLoopGroup: configuration.eventLoopGroup)
//            // Set the handlers that are applied to the accepted Channels
//            .childChannelInitializer{
//                $0.pipeline.addHandler(mainHandler)
//            }
//            .bind(to: configuration.address)
//            .wait()
//        guard let localAddress = channel.localAddress else {
//            fatalError("Address was unable to bind. Please check that the socket was not closed or that the address family was understood.")
//        }
//        print("Server started and listening on \(localAddress)")
//        let server = Self.init(configuration: configuration, channel: channel)
//        mainHandler.server(server, didBind: configuration)
//        return server
//    }
//}


