//
//  Nebula.swift
//
//
//  Created by Grady Zhuo on 2020/11/28.
//

import Foundation
import NIO

public class Nebula{

    public var galaxies: [String:SocketAddress] = [:]
    
    public static let standard:Nebula = {
//        let address = try! SocketAddress(ipAddress: "::1", port: 9000)
//        let MatterTransferClient<StandardGalaxy>.cloneAstral(from: address)
//        let galaxyClient = try! StandardGalaxy.client(target: address)
        return Nebula()
    }()
    
    
    internal func getAddress(_ : Astral.Protocol) throws ->SocketAddress?{
        let address = try! SocketAddress(ipAddress: "::1", port: 9000)
        return address
    }
    
//    init(galaxies: [SocketAddress]=[]) {
//        galaxies.forEach {
//            self.add(galaxy: $0)
//        }
//    }
//
//    public func galaxy(namespace: String)->GalaxyClient?{
//        return self.galaxies[namespace]
//    }
//
//
//    public func add(galaxy: GalaxyClient){
//        self.galaxies[galaxy.name] = galaxy
//    }
//
//    public func add(galaxies: [GalaxyClient]){
//        galaxies.forEach {
//            self.add(galaxy: $0)
//        }
//    }
//    public static func amas(name: String)->AmasClient{
//        return MatterTransferClient<DirectAmas>
//    }
    
    
    public func register<Source: Astral, Target: Astral>(source: Source, target: Target){
        
    }
    
    public func register(amas: Amas, label: String){
        
    }

//    public func pair(namespace: String)->Planet{
////        let matter = PairMatter(body: .init())
//        
//    }
//
//    public func push(event:String, data:Data)->Planet{
//
//    }
//
//    public func pull(event: String)->Planet{
//
//    }

}


