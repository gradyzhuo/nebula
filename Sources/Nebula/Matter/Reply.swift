//
//  File.swift
//  
//
//  Created by 卓廷叡 on 2021/1/7.
//

import Foundation
import SwiftProtobuf

public struct ReplyMatter<MatterType: MatterTransferType>:ProtoBufMatter {
    public typealias Body = MatterType.ReplyBody

    public var type: MatterType
    public var body: Body
    
    public static func `as`(type: MatterType, _ populator: ( _ body: inout Body) throws->Void) rethrows ->Self{
        let body = try Self.Body.with { body in
            try populator(&body)
        }
        return Self.init(type: type, body: body)
    }
    
    public init(type: MatterType, body: Body){
        self.type = type
        self.body = body
    }
    
    public init(body: MatterType.ReplyBody) {
        self.init(type: .reply, body: body)
    }

}

//public struct TestReplyMatter<Body: Message>:ProtoBufMatter {
//    public var activity: MatterMethod{ .reply }
//
//    public private(set) var body: Body
//    
//    public init(){
//        self.init(body: Body.with{
//            
//        })
//    }
//    
//    public init(body: Body) {
//        self.body = body
//    }
//    
//    
//}
