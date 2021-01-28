//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2020/12/29.
//

import Foundation
import Nebula
import NIO
import Runtime

//class EmbeddingService: ServiceStellaire{
//
//}

//class W2V: Service {
//    var name: String{
//        return "W2V"
//    }
//
//    func handle(_ parameters: [String : Codable]) -> Codable {
//        return "YYY"
//    }
//
//    subscript(dynamicMember member: String) -> Any {
//        return "XXX"
//    }
//
//}

let address = try SocketAddress(ipAddress: "::1", port: 7000)
let stellaire = ServiceStellar(name: "Embedding")

var w2v = Service(name: "w2v", version: "2020-12-31")
stellaire.add(service: w2v)

w2v.add(method: "wordVector") { (parameters) -> Codable in
    print(parameters)
    return "hello"
}

//let r = w2v("wordVector", with: ["words":["b", "c"]])
//print(r)
let amasAddress = try SocketAddress(ipAddress: "::1", port: 8001)
let delegate = StellarClientDelegate<ServiceStellar>()
let amasClient = try DirectAmas.client(target: amasAddress).delegate(delegate)
try amasClient.register(stellar: stellaire)

let builder = MatterTransferServer.build(with: stellaire, address: address)
let server = try builder.bind()
try server.listen()
