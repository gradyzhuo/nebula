//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2021/1/16.
//

import Foundation
import NIO

//TODO: - 補 client 取得 attribute
public class StandardGalaxy: Galaxy {
    
    public var identifier: UUID
    public var name: String
    
    public internal(set) var amases: [String: Channel] = [:]
    
    public init(name: String, identifier: UUID = UUID()) {
        self.identifier = identifier
        self.name = name
    }
}
