//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2020/12/28.
//

import Foundation

public struct FindMatter:ProtoBufMatter {
    public typealias MatterType = Find
    public typealias Reply = ReplyMatter<MatterType>
    public typealias Body = Nebula_FindBody
    
    public var type: MatterType
    public var body: Body
    
    public var serviceName: String{
        set{
            self.body.serviceName = newValue
        }
        get{
            return self.body.serviceName
        }
    }
    
    public init(type: MatterType, body: Body){
        self.type = type
        self.body = body
    }

    
    public init(body: MatterType.SendBody) {
        self.init(type: .default, body: body)
    }
}
