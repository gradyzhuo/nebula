//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2020/12/27.
//

import Foundation

/**
 bool visible    = 1;
 bool unregister = 2;
 string astral_name = 3;
 repeated string service_names = 4;
 */
public struct RegisterMatter:ProtoBufMatter {
    public typealias MatterType = Register
    public typealias Body = Nebula_RegisterBody

    public var type: MatterType
    public var body: Body

    public var visible: Bool{
        set{
            self.body.visible = newValue
        }
        get{
            return self.body.visible
        }
    }
    
    public var astralName: String{
        set{
            self.body.astralName = newValue
        }
        get{
            return self.body.astralName
        }
    }
    
    public var services:[String]{
        set{
            self.body.services = newValue
        }
        get{
            return self.body.services
        }
    }
    
    public init(astral name: String, services: [String] = [], visible: Bool = true, type: MatterType = .register){
        self.init(type: type, body: Body.with({ body in
            body.astralName = name
            body.services = services
            body.visible = visible
        }))
    }
    
    public init(type: MatterType, body: Body){
        self.type = type
        self.body = body
    }

    
    public init(body: MatterType.SendBody) {
        self.init(type: .default, body: body)
    }

}


extension RegisterMatter{
    
    public struct Reply: ProtoBufMatter{
        public typealias Reply = Never
        public typealias MatterType = Register
        public typealias Body = Nebula_RegisterReplyBody
        
        public var type: MatterType
        public var body: Body
        
        public static var method: MatterActivity{
            return .reply
        }
        
        public init(status: String){
            self.init(body: Body.with{ body in
                body.status = status
            })
        }
        
        public init(type: MatterType, body: Body){
            self.type = type
            self.body = body
        }

        
        public init(body: MatterType.ReplyBody) {
            self.init(type: .reply, body: body)
        }
        
    }
}
