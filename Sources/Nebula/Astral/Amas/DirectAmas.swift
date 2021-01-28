//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2021/1/16.
//

import Foundation
import NIO
/// Stellar pool
public class DirectAmas: Amas{
    public internal(set) var identifier: UUID
    public internal(set) var name: String
    
    public internal(set) var galaxy: GalaxyClient?
    public internal(set) var supportServices: [String] = []
    
    public internal(set) var stellaires: [String:Channel] = [:]
    
    public init(name: String, identifier: UUID = UUID()) {
        self.identifier = identifier
        self.name = name
    }
    
}
