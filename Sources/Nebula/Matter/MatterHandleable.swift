//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2021/1/12.
//

import Foundation
import NIO

public protocol MatterHandleable{
//    func handle(context: ChannelHandlerContext, matter: ReplyMatter)
    func handle(context: ChannelHandlerContext, matter: CloneMatter) throws ->Result<CloneMatter.Reply, Error>?
    func handle(context: ChannelHandlerContext, matter: AskAttributeMatter) throws ->Result<AskAttributeMatter.Reply, Error>?
    func handle(context: ChannelHandlerContext, matter: ActivateMatter) throws ->Result<ActivateMatter.Reply, Error>?
    func handle(context: ChannelHandlerContext, matter: RegisterMatter) throws ->Result<RegisterMatter.Reply, Error>?
    func handle(context: ChannelHandlerContext, matter: FindMatter) throws ->Result<FindMatter.Reply, Error>?
    func handle(context: ChannelHandlerContext, matter: PairMatter) throws ->Result<PairMatter.Reply, Error>?
    func handle(context: ChannelHandlerContext, matter: CallMatter) throws ->Result<CallMatter.Reply, Error>?
}

extension MatterHandleable{
    public func handle(context: ChannelHandlerContext, matter: AskAttributeMatter) throws -> Result<AskAttributeMatter.Reply, Error>? {
        return nil
    }
    
    public func handle(context: ChannelHandlerContext, matter: FindMatter) throws -> Result<FindMatter.Reply, Error>? {
        return nil
    }
    
    public func handle(context: ChannelHandlerContext, matter: PairMatter) throws -> Result<ReplyMatter<Pair>, Error>? {
        return nil
    }

    
    public func handle(context: ChannelHandlerContext, matter: CallMatter) throws -> Result<ReplyMatter<Call>, Error>? {
        return nil
    }
    
    public func handle(context: ChannelHandlerContext, matter: ActivateMatter) throws -> Result<ReplyMatter<Activate>, Error>? {
        return nil
    }
    
    public func handle(context: ChannelHandlerContext, matter: RegisterMatter) throws -> Result<RegisterMatter.Reply, Error>? {
        return nil
    }
    
    public func handle(context: ChannelHandlerContext, matter: CloneMatter) throws -> Result<CloneMatter.Reply, Error>? {
        return nil
    }
    
//    public func handle(context: ChannelHandlerContext, matter: ReplyMatter) {
//
//    }
}

extension MatterHandleable where Self: Delegate{
    
    public func handle(context: ChannelHandlerContext, data: Data) throws {
        do{
            let bytes = data.map{ $0 }
            var resultBytes: [UInt8] = []
            if let type = try? MatterActivity(bytes: data[MatterBytesRange.type]) {
                switch type{
                case .clone:
                    let matter = try CloneMatter(serializedBytes: bytes)
                    if let result = try self.handle(context: context, matter: matter)?.get(){
                        resultBytes = try result.serialized()
                    }else{
                        print(#function, "clone no result.")
                    }
                    
                case .activate:
                    let matter = try ActivateMatter(serializedBytes: bytes)
                    if let result = try self.handle(context: context, matter: matter)?.get(){
                        resultBytes = try result.serialized()
                    }else{
                        print(#function, "activate no result.")
                    }
                case .register:
                    let matter = try RegisterMatter(serializedBytes: bytes)
                    if let result = try self.handle(context: context, matter: matter)?.get(){
                        resultBytes = try result.serialized()
                    }else{
                        print(#function, "register no result.")
                    }
                case .find:
                    let matter = try FindMatter(serializedBytes: bytes)
                    if let result = try self.handle(context: context, matter: matter)?.get(){
                        resultBytes = try result.serialized()
                    }else{
                        print(#function, "find no result.")
                    }
                case .pair:
                    let matter = try PairMatter(serializedBytes: bytes)
                    if let result = try self.handle(context: context, matter: matter)?.get(){
                        resultBytes = try result.serialized()
                    }else{
                        print(#function, "pair no result.")
                    }
                case .call:
                    let matter = try CallMatter(serializedBytes: bytes)
                    if let result = try self.handle(context: context, matter: matter)?.get(){
                        resultBytes = try result.serialized()
                    }else{
                        print(#function, "call no result.")
                    }
                case .ask:
                    let matter = try AskAttributeMatter(serializedBytes: bytes)
                    if let result = try self.handle(context: context, matter: matter)?.get(){
                        resultBytes = try result.serialized()
                    }else{
                        print(#function, "ask no result.")
                    }
                case .reply:
//                    let matter = try ReplyMatter(serializedBytes: bytes)
//                    if let result = try self.handle(context: context, matter: matter)?.get(){
//                        resultBytes = try result.serialized()
//                    }else{
//                        print(#function, "no result.")
//                    }
//                    self.handle(context: context, matter: matter)
                    resultBytes = []
                    print("Reply")
                }
                
                let buffer = context.channel.allocator.buffer(bytes: resultBytes)
                _ = context.writeAndFlush(NIOAny(buffer))
            }
        }catch{
            print(error)
        }
        
    }
    
}



