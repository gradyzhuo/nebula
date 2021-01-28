//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2021/1/12.
//

import Foundation

public struct PairMatter:ProtoBufMatter{
    public typealias MatterType = Pair
    
    public typealias Reply = ReplyMatter<Pair>
    
    public typealias Body = Nebula_PairBody

    public var type: MatterType
    public var body: Body
    
    public init(type: MatterType, body: Body){
        self.type = type
        self.body = body
    }
    
    public init(body: MatterType.SendBody) {
        self.init(type: .default, body: body)
    }
    
}
