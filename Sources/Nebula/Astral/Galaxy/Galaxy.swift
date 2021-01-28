//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2020/12/22.
//

import Foundation
import NIO


public protocol Galaxy: Astral{
//    var amases:[String:Channel] { get }
}

extension Galaxy{
    public static var category: AstralCategory{ .galaxy }
}

public protocol GalaxyClient{
    func register<AmasType: Amas>(amas:AmasType) throws
}


// MARK: - rpc for amas
extension MatterTransferClient:GalaxyClient where AstralType: Galaxy{
//    public func register(amas identifier: UUID, name: String, address: SocketAddress) {
//        do {
//            let matter = RegisterMatter(astral: name)
//            _ = try self.fire(matter: matter)
//        }catch{
//            print("register amas (\(name)) error: \(error)")
//        }
//    }
    
    public func register<AmasType: Amas>(amas:AmasType) throws {
        let matter = RegisterMatter(astral: amas.name)
        _ = try self.fire(matter: matter)
    }

    public func test() throws {
        let matter = AskAttributeMatter(type: .attribute, attribute: "hello")
        try self.fire(matter: matter)
    }
}

//public protocol GalaxyClientDelegate{
//
//}
