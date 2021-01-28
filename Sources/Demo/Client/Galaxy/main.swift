//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2020/12/28.
//

import Foundation
import Nebula
import NIO


//let nebula = NebulaConfig.standard
//let galaxyClient = nebula.galaxy(namespace: "G1")
//galaxyClient?.get(attribute: "amases")
//print(try galaxy.client?.get(attribute: "amases"))

let address = try SocketAddress(ipAddress: "::1", port: 9000)
let client = try StandardGalaxy.client(target: address, delegate: GalaxyClientDelegate<StandardGalaxy>())

try client.test()

//let amasAddress = try SocketAddress(ipAddress: "::1", port: 8000)
//client.register(amas: UUID(), name: "hello", address: amasAddress)

//let a = try! galaxy.client!.request(data: "1".data(using: .utf8)!)
//let b = try! galaxy.client!.request(data: "2".data(using: .utf8)!)

//print("1:", String(buffer: a), "2:", String(buffer: b))
//print(String(buffer: responseA))

RunLoop.main.run()
