//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2021/1/20.
//

import Foundation
import NIO
import Nebula

let address = try SocketAddress(ipAddress: "::1", port: 7001)
let client = try ServiceStellar.client(target: address)
print(client.name, client.identifier)
let results = try client.call(service: "W2V", method: "wordVector", argumentsDict: ["words":["x", "y", "z"], "d": ["a":["c":"d"]]])
print(String(buffer: results))
//let bytes = results.getBytes(at: results.readerIndex, length: results.readableBytes)




RunLoop.main.run()
