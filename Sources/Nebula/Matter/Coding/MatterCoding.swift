//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2020/12/28.
//

import Foundation
import NIO

extension MatterBytesRange{
    internal static func available(buffer: ByteBuffer)->Bool{
        return buffer.readableBytes >= (bytesLength.type + bytesLength.stamp + bytesLength.check + bytesLength.size)
    }
}

internal struct MatterToByteEncoder<OutboundIn: Matter>: MessageToByteEncoder{
    
    func encode(data: OutboundIn, out: inout ByteBuffer) throws {
        let bytes:[UInt8] = try data.serialized()
        out.writeBytes(bytes)
    }
}


internal struct ByteToMatterDecoder: ByteToMessageDecoder{
    typealias InboundOut = Matter
    
    mutating func decode(context: ChannelHandlerContext, buffer: inout ByteBuffer) throws -> DecodingState {
        
        guard MatterBytesRange.available(buffer: buffer) else {
            return .needMoreData
        }
        
//        MatterBytesRange.divide(bytes: buffer.getBytes(at: <#T##Int#>, length: <#T##Int#>))
        
        guard let stampBytes = buffer.getBytes(at: buffer.readerIndex, length: MatterBytesRange.stamp.count) else {
            // The first 16 bytes of the matter indicate the stamp (UUID)
            return .needMoreData
        }
        
        guard let kindBytes = buffer.getBytes(at: buffer.readerIndex + 2, length: 2) else {
//            logger.error("Can't get messageTypeID bytes")
            return .continue
        }

        
        
        return .needMoreData
    }
    
    mutating func decodeLast(context: ChannelHandlerContext, buffer: inout ByteBuffer, seenEOF: Bool) throws -> DecodingState {
        return .continue
    }
    
    
    
}
