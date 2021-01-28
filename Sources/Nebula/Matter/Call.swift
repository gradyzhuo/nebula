//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2021/1/12.
//

import Foundation

public struct CallMatter:ProtoBufMatter{
    public typealias MatterType = Call
    public typealias Reply = ReplyMatter<Call>
    public typealias Body = MatterType.SendBody
    
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
    
    public var methodName: String{
        set{
            self.body.methodName = newValue
        }
        get{
            return self.body.methodName
        }
    }
    
    public var arguments: [Argument]{
        set{
            let encoder = JSONEncoder()
            let data = try! encoder.encode(newValue)
            self.body.arguments = data
        }
        get{
            let decoder = JSONDecoder()
            return try! decoder.decode([Argument].self, from: self.body.arguments)
        }
    }
    
//    public var parameters: [String:Codable]{
//        set{
//            
//        }
//        
//        get{
////            [String:Codable]
//            let decoder = JSONDecoder()
//            return decoder.decode([String:Codable].self, from: self.body.parameters)
//        }
//    }
    
    public init(service: String, method: String, arguments: [Argument]){
        self.init(body: .with{
            $0.serviceName = service
            $0.methodName = method
        })
        self.arguments = arguments
    }
    
    public init(service: String, method: String, arguments: Argument...){
        self.init(service: service, method: method, arguments: arguments)
    }
    
    public init(type: MatterType, body: Body){
        self.type = type
        self.body = body
    }
    
    public init(body: MatterType.SendBody) {
        self.init(type: .reply, body: body)
    }
    
}
