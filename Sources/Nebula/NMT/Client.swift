//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2020/12/24.
//

import Foundation
import NIO
import NIOExtras

//public class ClientChannelInboundHandler: ChannelInboundHandler{
//    public typealias InboundIn = ByteBuffer
//    public typealias OutboundOut = (ByteBuffer, EventLoopPromise<ByteBuffer>)
//
//    public internal(set) var delegates: [ClientDelegate]
//
//    public init(delegates: ClientDelegate...){
//        self.delegates = delegates
//    }
//
//    public init(delegates: [ClientDelegate]){
//        self.delegates = delegates
//    }
//
//    public func add(delegate: ClientDelegate){
//        self.delegates.append(delegate)
//    }
//
//    public func add(delegates: [ClientDelegate]){
//        self.delegates.append(contentsOf: delegates)
//    }
//
//}
//
//extension ClientChannelInboundHandler{
//    public typealias OutboundIn = ByteBuffer
//
////    public func register(context: ChannelHandlerContext, promise: EventLoopPromise<Void>?) {
////        context.register(promise: promise)
////    }
//
////    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
////        print("client channel Read")
////        let bytebuffer = self.unwrapInboundIn(data)
////
////        if let bytes = bytebuffer.getBytes(at: bytebuffer.readerIndex, length: bytebuffer.readableBytes){
////            if try! self.handle(context: context, data: Data(bytes)){
////                print("here???!!!!")
////                context.fireChannelRead(data)
////            }
////        }else{
////            print("not Data...")
//////            context.fireChannelRead(data)
////        }
////    }
//
//    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
//        print("client channel Read")
//        let bytebuffer = self.unwrapInboundIn(data)
//
//        guard let bytes = bytebuffer.getBytes(at: bytebuffer.readerIndex, length: bytebuffer.readableBytes) else {
//            print("no bytes")
//            context.fireChannelRead(data)
//            return
//        }
//
//        guard let matter = try? MatterActivity(bytes: bytes) else {
//            print("no matter")
//            context.fireChannelRead(data)
//            return
//        }
//
//        print("----------here????")
//
//    }
//
//}


public struct ClientBuilder<DelegateType: Delegate>{
    var handler:NMTClientInboundHandler = NMTClientInboundHandler()
    var address: SocketAddress
    var eventLoopGroup: EventLoopGroup
    var channelFuture: EventLoopFuture<Channel>
    
    internal init(handler: NMTClientInboundHandler, address: SocketAddress, eventLoopGroup: EventLoopGroup, channelFuture: EventLoopFuture<Channel>) {
        self.handler = handler
        self.address = address
        self.eventLoopGroup = eventLoopGroup
        self.channelFuture = channelFuture
    }
    
}

public protocol Client {
    var name: String { get }
    var identifier: UUID { get }
    var channel: Channel { get }
    var targetAddress: SocketAddress { get }
    
//    static func connect(to address: SocketAddress, eventLoopGroup: EventLoopGroup) -> EventLoopFuture<Channel>
}

extension Client{
    internal static func bootstrap(eventLoopGroup:EventLoopGroup? = nil, initializer:@escaping (Channel)->EventLoopFuture<Void>) -> ClientBootstrap{
        let eventLoopGroup = eventLoopGroup ?? MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        return ClientBootstrap(group: eventLoopGroup)
            .channelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
            .channelInitializer(initializer)
    }
}

extension Channel {
    internal func _request(data: Data) -> EventLoopFuture<ByteBuffer>{
        let messageBuffer = self.allocator.buffer(bytes: data)
        let promise = self.eventLoop.makePromise(of: ByteBuffer.self)
        let requestInfo = NIOAny((messageBuffer, promise))
        self.writeAndFlush(requestInfo, promise: nil)
        return promise.futureResult
    }
    
    public func request(data: Data) throws -> ByteBuffer{
        return try self._request(data: data).wait()
    }
}

public final class MatterTransferClient<AstralType: Astral>: Client{
    public typealias InboundIn = ByteBuffer
    
    public var name: String
    public var identifier: UUID
    public let targetAddress: SocketAddress
    public let channel: Channel
    internal var handler: NMTClientInboundHandler
    internal var astralCategory: AstralCategory = .amas
    
    internal init(target: SocketAddress, channel: Channel, handler: NMTClientInboundHandler,name: String, identifier: UUID) {
        self.targetAddress = target
        self.channel = channel
        self.name = name
        self.identifier = identifier
        self.handler = handler
    }
    
    public func delegate(_ getter: @autoclosure ()->NMTClientDelegate)->Self{
        self.handler.add(delegate: getter())
        return self
    }
}


extension MatterTransferClient {
    
    internal func request(data: Data) throws ->ByteBuffer{
        return try Self.request(to: self.targetAddress, data: data)
    }
    
    public func request<T:Matter>(matter: T) throws ->ByteBuffer{
        let matterData:Data = try matter.serialized()
        return try self.request(data: matterData)
    }
    
    public func fire<T:Matter>(matter: T) throws{
        try self.writeAndFlush(matter: matter)
    }
    
    
    public func writeAndFlush<T:Matter>(matter: T) throws{
        let matterBytes:[UInt8] = try matter.serialized()
        let buffer = self.channel.allocator.buffer(bytes: matterBytes)
        try self.channel.writeAndFlush(buffer).wait()
    }
    
//    public func get(attribute: String) throws -> ByteBuffer{
//        let matter = AskMatter(attribute: attribute)
//        var buffer = try Self.request(to: self.target, data: matter.serialized())
//        print(buffer)
//        return buffer
//    }
}


extension MatterTransferClient{
    
    public static func request(to address: SocketAddress, data: Data, eventLoopGroup: EventLoopGroup? = nil) throws ->ByteBuffer{
        let handler = NMTClientInboundHandler()
        let channelFuture = Self.bootstrap(eventLoopGroup: eventLoopGroup){ channel in
            channel.pipeline.addHandler(RequestResponseHandler<ByteBuffer, ByteBuffer>(), name: "request-response")
                .flatMap { _ in
                    channel.pipeline.addHandler(handler)
                }
        }.connect(to: address)
        let resultFuture = channelFuture.flatMap { channel -> EventLoopFuture<ByteBuffer> in
            let messageBuffer = channel.allocator.buffer(bytes: data)
            let promise = channel.eventLoop.makePromise(of: ByteBuffer.self)
            let requestInfo = NIOAny((messageBuffer, promise))
            channel.writeAndFlush(requestInfo, promise: nil)
            return promise.futureResult
        }
        return try resultFuture.wait()
    }
    
    public static func connect(to address: SocketAddress, eventLoopGroup: EventLoopGroup?) throws -> Self {
        let astralBuffer = try Self.cloneAstral(from: address)
        let clonedBytes = astralBuffer.getBytes(at: astralBuffer.readerIndex, length: astralBuffer.readableBytes)
        let reply = try CloneMatter.Reply(serializedBytes: clonedBytes!)
        
        let handler = NMTClientInboundHandler()
        let channel = try Self.bootstrap(eventLoopGroup: eventLoopGroup){ channel in
            channel.pipeline.addHandler(handler, name: "main")
        }.connect(to: address)
        .wait()
        return Self.init(target: address, channel: channel, handler: handler, name: reply.name, identifier: reply.identifier)
    }
    
    internal static func cloneAstral(from address: SocketAddress, eventLoopGroup: EventLoopGroup? = nil) throws->ByteBuffer{
        let matter = CloneMatter(body: CloneMatter.MatterType.SendBody())
        let responseBuffer = try Self.request(to: address, data: matter.serialized(), eventLoopGroup: eventLoopGroup)
        return responseBuffer
    }
}
