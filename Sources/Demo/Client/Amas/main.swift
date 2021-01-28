//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2020/12/27.
//

import Foundation
import Nebula
import NIO

//let clone = Clone.astral
//let bytes = clone.bytes
//print(bytes, try Clone(bytes: bytes))

//let matter = CloneMatter(body: Nebula_CloneBody())
//let bytes:[UInt8] = try matter.serialized()
//print(bytes)
do{
//    let amas1 = DirectAmas(name: "test")
//    let nebula = Nebula.standard
    let address = try SocketAddress(ipAddress: "::1", port: 8001)
    let client = try DirectAmas.client(target: address)
    print(client.astral.name)
    
    print(Ask.attribute.bytes(), Ask(bytes: Ask.attribute.bytes()))
    
//    print(try amas1.client?.get(attribute: "test"))
    
//    let matter = RegisterMatter(astral: amas1)
//    let bytes:[UInt8] = matter.serialized()
//    print(matter.identifier.uuidString)
//    let uuidBytes = bytes[0..<16]
//    print(uuidBytes)
//    let uuid2 = try UUID(bytes: uuidBytes)
//    print(uuid2.uuidString)
//    print(bytes[18..<22])
//    print(bytes[22..<32])
//    let body = try Nebula_RegisterBody(contiguousBytes: bytes[22..<32])
//    print(body.astral)
//    print(bytes[32..<34])
    
    
}
catch{
    print("error:", error)
}




RunLoop.main.run()

