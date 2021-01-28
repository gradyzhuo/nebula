//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2021/1/14.
//

import Foundation
import NIO

public struct NMTConfiguration{
    
    public var address: SocketAddress
    public var eventLoopGroup: EventLoopGroup
    
    public init(address: SocketAddress, eventLoopGroup: EventLoopGroup? = nil){
        self.address = address
        self.eventLoopGroup = eventLoopGroup ?? MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
    }
}


public protocol MatterTransferProtocol{
    associatedtype AstralType: Astral

    var astral: AstralType { get }
}
