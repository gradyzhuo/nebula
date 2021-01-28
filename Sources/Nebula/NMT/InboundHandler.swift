//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2021/1/27.
//

import Foundation
import NIO

//public typealias NMTClientInboundHandler<T:NMTClientDelegate> = NMTInboundHandler<T>
public final class NMTClientInboundHandler{
    
    public internal(set) var delegates: [NMTClientDelegate]
    
    public init(delegates: NMTClientDelegate...){
        self.delegates = delegates
    }
    
    public init(delegates: [NMTClientDelegate]){
        self.delegates = delegates
    }
    
    public func add(delegate: NMTClientDelegate){
        self.delegates.append(delegate)
    }
    
    public func add(delegates: [NMTClientDelegate]){
        self.delegates.append(contentsOf: delegates)
    }

    public func handle(context: ChannelHandlerContext, data: Data) throws {
        print("handle(context: ChannelHandlerContext, data: Data), \(self.delegates.count), \(self.delegates)")
        try self.delegates.forEach {
            try $0.handle(context: context, data: data)
        }
    }
}

extension NMTClientInboundHandler:ChannelInboundHandler{
    public typealias InboundIn = ByteBuffer
    public typealias OutboundIn = ByteBuffer
    
//MARK: - InboundHandler

//    public func channelRegistered(context: ChannelHandlerContext) {
//        print("channelRegistered:", context)
//    }
//
//    public func channelUnregistered(context: ChannelHandlerContext) {
//        print("channelUnregistered:", context)
//    }
//
//    public func channelActive(context: ChannelHandlerContext) {
//        print("channelActive:", context)
//    }
//
//    public func channelInactive(context: ChannelHandlerContext) {
//        print("channelInactive:", context)
//    }
    
    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        print("client channel Read")
        let bytebuffer = self.unwrapInboundIn(data)

        guard let bytes = bytebuffer.getBytes(at: bytebuffer.readerIndex, length: bytebuffer.readableBytes) else {
            context.fireChannelRead(data)
            return
        }
        
        guard let _ = try? MatterActivity(bytes: bytes) else {
            context.fireChannelRead(data)
            return
        }
        
        do {
            try self.handle(context: context, data: Data(bytes))
        }catch{
            context.fireChannelRead(data)
        }
        
    }
    
    
    
//    public func channelReadComplete(context: ChannelHandlerContext) {
//
//    }
//
//    public func handlerAdded(context: ChannelHandlerContext) {
//
//    }
//
//    public func handlerRemoved(context: ChannelHandlerContext) {
//
//    }
//
//    public func channelWritabilityChanged(context: ChannelHandlerContext) {
//
//    }
//
//    public func errorCaught(context: ChannelHandlerContext, error: Error) {
//
//    }
//
//    public func userInboundEventTriggered(context: ChannelHandlerContext, event: Any) {
//
//    }
}



public final class NMTServerInboundHandler: NMTServerDelegate{
    
    public internal(set) var delegates: [NMTServerDelegate]
    
    public init(delegates: NMTServerDelegate...){
        self.delegates = delegates
    }
    
    public init(delegates: [NMTServerDelegate]){
        self.delegates = delegates
    }
    
    public func add(delegate: NMTServerDelegate){
        self.delegates.append(delegate)
    }
    
    public func add(delegates: [NMTServerDelegate]){
        self.delegates.append(contentsOf: delegates)
    }

    public func handle(context: ChannelHandlerContext, data: Data) throws {
        print("handle(context: ChannelHandlerContext, data: Data), \(self.delegates.count), \(self.delegates)")
        try self.delegates.forEach {
            try $0.handle(context: context, data: data)
        }
    }
}

extension NMTServerInboundHandler {
    public func server(didBind server: Server) {
        self.delegates.forEach {
            $0.server(didBind: server)
        }
    }
}


extension NMTServerInboundHandler:ChannelInboundHandler{
    public typealias InboundIn = ByteBuffer
    public typealias OutboundIn = ByteBuffer
    
//MARK: - InboundHandler

//    public func channelRegistered(context: ChannelHandlerContext) {
//        print("channelRegistered:", context)
//    }
//
//    public func channelUnregistered(context: ChannelHandlerContext) {
//        print("channelUnregistered:", context)
//    }
//
//    public func channelActive(context: ChannelHandlerContext) {
//        print("channelActive:", context)
//    }
//
//    public func channelInactive(context: ChannelHandlerContext) {
//        print("channelInactive:", context)
//    }
    
    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        print("client channel Read")
        let bytebuffer = self.unwrapInboundIn(data)

        guard let bytes = bytebuffer.getBytes(at: bytebuffer.readerIndex, length: bytebuffer.readableBytes) else {
            context.fireChannelRead(data)
            return
        }
        
        guard let _ = try? MatterActivity(bytes: bytes) else {
            context.fireChannelRead(data)
            return
        }
        
        do {
            try self.handle(context: context, data: Data(bytes))
        }catch{
            context.fireChannelRead(data)
        }
        
    }
    
    
    
//    public func channelReadComplete(context: ChannelHandlerContext) {
//
//    }
//
//    public func handlerAdded(context: ChannelHandlerContext) {
//
//    }
//
//    public func handlerRemoved(context: ChannelHandlerContext) {
//
//    }
//
//    public func channelWritabilityChanged(context: ChannelHandlerContext) {
//
//    }
//
//    public func errorCaught(context: ChannelHandlerContext, error: Error) {
//
//    }
//
//    public func userInboundEventTriggered(context: ChannelHandlerContext, event: Any) {
//
//    }
}
