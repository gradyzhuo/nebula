//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2021/1/24.
//

import Foundation
@testable import Nebula
import NIO

let address = try SocketAddress(ipAddress: "::1", port: 7000)

let planet = RoguePlanet<ServiceStellar>(name: "TagEstimation", identifier: UUID())
try planet.connect(to: address)

RunLoop.main.run()
