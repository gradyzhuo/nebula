//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2021/1/27.
//

import Foundation

public class GalaxyClientDelegate<T: Galaxy>: MatterTransferClientDelegate{
    public typealias AstralType = T
    
    public var client: MatterTransferClient<AstralType>?
    
    public required init() {
        
    }
}
