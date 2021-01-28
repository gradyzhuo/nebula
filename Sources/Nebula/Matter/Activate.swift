//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2020/12/27.
//

import Foundation

public struct ActivateMatter:ProtoBufMatter {
    
    public typealias MatterType = Activate
    public typealias Reply = ReplyMatter<MatterType>
    public typealias Body = Nebula_ActivateBody
    
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
    
//    public var astralId: UUID{
//        
//    }
//    
//    public var astralName: String{
//        
//    }
//
//    public var astral: Nebula_Astral{
//        set{
//            self.body.astral = newValue
//        }
//        get{
//            return self.body.astral
//        }
//    }
//
//    public init(astral: Astral, visible:Bool=false){
//        let pbAstral = Nebula_Astral.with {
//            $0.name = astral.name
//            $0.type = Nebula_Astral.TypeEnum.init(rawValue: Int(astral.type.rawValue)) ?? .any
//        }
//        self.body = .with {
//            $0.astral = pbAstral
//            $0.visible = visible
//        }
//    }
//
    public init(astral identifier: UUID, name: String, visible: Bool=true, type:MatterType = .activate){
        self.init(type: type, body: .with { body in
            body.astralName = name
            body.visible = visible
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
