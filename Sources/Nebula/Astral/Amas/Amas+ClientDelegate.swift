//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2021/1/27.
//

import Foundation
import NIO

public class AmasClientDelegate<AmasType: Amas>: MatterTransferClientDelegate{
    public typealias AstralType = AmasType
    
    public var client: MatterTransferClient<AstralType>?
    
    public required init() {
        
    }
}


extension AmasClientDelegate{
    public func handle(context: ChannelHandlerContext, matter: ActivateMatter) throws -> Result<ActivateMatter.Reply, Error>? {
        print("...... ActivateMatter:", matter)
        return nil
    }
}
