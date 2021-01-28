//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2020/12/19.
//

import Foundation
import NIO

public protocol Amas : Astral {
    var galaxy: GalaxyClient? { get }
    var supportServices:[String] { get }
    var stellaires:[String: Channel] { get }
}

extension Amas {
    public static var category: AstralCategory{ .amas }
}

public protocol AmasClient{
    func register(stellar:Stellar) throws
    func unregister(service name: String)
    func perform(service: Service)
}

extension MatterTransferClient:AmasClient where AstralType: Amas{
    
    public func register(stellar:Stellar) throws {
        let matter = RegisterMatter(astral: stellar.name, services: Array(stellar.availableServices.keys))
        _ = try self.fire(matter: matter)
    }
    
    public func unregister(service name: String) {
        
    }
    
    public func perform(service: Service) {
        
    }
    
}


