//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2021/1/25.
//

import Foundation
import NIO
import Nebula

let galaxy = StandardGalaxy(name: "Galaxy1")
let galaxyServer = try MatterTransferServer
    .build(with: galaxy, address: try SocketAddress(ipAddress: "::1", port: 9000))
    .bind()

let amas = DirectAmas(name: "A1", identifier: UUID())
let amasServer = try MatterTransferServer
    .build(with: amas, address: try SocketAddress(ipAddress: "::1", port: 8001))
    .bind()

// MARK: Amas

try amasServer.register(to: galaxy.name)

_ = try galaxyServer.closeFuture
    .and(amasServer.closeFuture)
    .wait()

//try client.test()
