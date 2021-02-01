//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2021/1/24.
//

import Foundation
import Nebula
import NIO

let address = try SocketAddress(ipAddress: "::1", port: 7001)

let embedding = try RoguePlanet<ServiceStellar>.locate(to: address)
//try planet.connect(to: address)
//print(planet.W2V.wordVector)
let result = embedding.W2V.wordVector(words:["慢跑", "反光", "排汗", "乾爽", "支撐", "止滑", "登山", "健行"])
print("result:", result)
RunLoop.main.run()
