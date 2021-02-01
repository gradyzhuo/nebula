//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2021/2/1.
//

import Foundation

public struct ReturnWrapper{
    public internal(set) var data: Data?
    
    public static func wrap<T: Encodable>(value: T?) throws ->Self{
        guard let value = value else {
            return .init(data: nil)
        }
        let encoder = JSONEncoder()
        let data = try encoder.encode(value)
        return .init(data: data)
    }
    
    public func unwrap<T: Decodable>(to type: T.Type) throws ->T?{
        guard let data = self.data else {
            return nil
        }
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
