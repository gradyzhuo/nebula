//
//  File.swift
//  
//
//  Created by 卓廷叡 on 2021/1/7.
//

import Foundation

public struct AskAttributeMatter:ProtoBufMatter {
    public typealias MatterType = Ask
    public typealias Body = MatterType.SendBody

    public var type: MatterType
    public var body: Body
    
    public var attribute: String{
        set{
            self.body.attribute = newValue
        }
        get{
            return self.body.attribute
        }
    }
    
    public init(type: MatterType, attribute: String){
        self.init(type: type, body: .with {
            $0.attribute = attribute
        })
    }
    

    public init(type: MatterType, body: Body){
        self.type = type
        self.body = body
    }

    
    public init(body: MatterType.SendBody) {
        self.init(type: .default, body: body)
    }


}

extension AskAttributeMatter{
    public struct Reply: ProtoBufMatter{
        public typealias MatterType = Ask
        public typealias Body = Nebula_AskAttributeReplyBody
        
        public var type: MatterType
        public var body: Body

        
        public init(type: MatterType, body: Body){
            self.type = type
            self.body = body
        }

        
        public init(body: MatterType.ReplyBody) {
            self.init(type: .reply, body: body)
        }
        
    }
}
