//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2020/12/19.
//

import Foundation
import Nebula
import NIO

do {
    let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
    let address = try SocketAddress(ipAddress: "::1", port: 9000)
    
//    let galaxy = StandardGalaxy(name: "Galaxy1", identifier: UUID())
    let galaxy = StandardGalaxy(name: "Galaxy1", identifier: UUID())
    let server = try MatterTransferServer
        .build(with: galaxy, address: address)
        .bind()
    print("identifier: ", server.astral.identifier)
    try server.listen()
//    try server.channel.closeFuture.wait()
//    let server = try MatterTransferServer.bind(on: address, with: galaxy)
//    let server = StandardGalaxy.server(address: address, name: "G1", identifier: UUID())
//    var server = StandardGalaxy.NMTServer(address: address, name: "G1", identifier: UUID())
//    try server.bind().channel.closeFuture.wait()
}catch{
    print("galaxy error:", error)
}

//RunLoop.main.run()

//let nebula = Nebula.standard
//nebula.add(galaxy: galaxy)
//print(nebula.galaxies)

/// useless?
//do{
//    let amas = try DirectAmas.connect(to: SocketAddress(ipAddress: "0.0.0.0", port: 9999), configuration: Configuration(namespace: "test"))
//    print("client:", amas.client)
//}
//catch{
//    print("xxx:", error)
//}
    //let amas = DirectAmas(configuration: Configuration(namespace: "test2"))
////try! amas.start(address: SocketAddress(ipAddress: "::1", port: 9000), eventLoopGroup: group)
////    .listen()
//do{
//    _ = try amas.connect(to: SocketAddress(ipAddress: "0.0.0.0", port: 9999))
//}catch{
//    print(error)
//}
//class TestAmas:DirectAmas {
//
//}
