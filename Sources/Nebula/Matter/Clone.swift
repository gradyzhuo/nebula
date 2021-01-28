////
////  File.swift
////
////
////  Created by Grady Zhuo on 2021/1/16.
////
//
import Foundation

public struct CloneMatter: ProtoBufMatter {
    public typealias MatterType = Clone
    public typealias Body = Nebula_CloneBody
    
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

extension CloneMatter{
    
    public struct Reply: ProtoBufMatter{
        public typealias Reply = Never
        public typealias MatterType = Clone
        public typealias Body = Nebula_CloneReplyBody
        
        public var name: String{
            set{
                self.body.name = newValue
            }
            get{
                return self.body.name
            }
        }
        
        public var identifier: UUID{
            set{
                self.body.identifier = newValue.data
            }
            get{
                return try! UUID(data: self.body.identifier)
            }
        }
        
        public var type: MatterType
        public var body: Nebula_CloneReplyBody
        
        public init(astral: Astral){
            self.init(name: astral.name, identifier: astral.identifier)
        }
        
        public init(name: String, identifier: UUID){
            self.init(body: .with{ body in
                body.name = name
                body.identifier = identifier.data
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
