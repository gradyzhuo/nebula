//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2020/12/26.
//

import Foundation
import Nebula
import NIO


//let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
let address = try! SocketAddress(ipAddress: "::1", port: 8001)
let amas = DirectAmas(name: "A1", identifier: UUID())
let server = try MatterTransferServer.build(with: amas, address: address)
    .bind()

try server.register(to: "Galaxy1")
//let server = try DirectAmas.server(target: address, name: "A1") //MatterTransferServer.bind(on: address, with: amas)

//let galaxy = NebulaConfig.standard.galaxy(namespace: galaxyName)
//galaxy?.register(amas: server.astral, address: server.address)

try server.listen()
//try! server.bind().channel.closeFuture.wait()


