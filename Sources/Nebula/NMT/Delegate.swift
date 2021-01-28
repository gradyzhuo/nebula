//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2021/1/16.
//

import Foundation
import NIO

public protocol Delegate{
    func handle(context: ChannelHandlerContext, data: Data) throws
}

public protocol NMTServerDelegate: Delegate{
    func server(didBind server: Server)
}

public protocol NMTClientDelegate: Delegate{
    
}

public protocol MatterTransferServerDelegate: NMTServerDelegate, MatterTransferProtocol, MatterHandleable{
    init(astral: Self.AstralType)
}

//public protocol MatterTransferClientDelegate: NMTClientDelegate, MatterHandleable{
//    init()
//}
public protocol MatterTransferClientDelegate: NMTClientDelegate, MatterHandleable{
    associatedtype AstralType: Astral
    
    var client: MatterTransferClient<AstralType>? { set get }
    init()
}

public class MatterTransferRequestDelegate<AstralType: Astral>: MatterTransferClientDelegate{
    public var client: MatterTransferClient<AstralType>?
    public required init() {
        
    }
}
