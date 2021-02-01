//
//  File.swift
//  
//
//  Created by Grady Zhuo on 2020/12/19.
//

import Foundation
import NIO
import AnyCodable


public protocol Stellar: CallableAstral{
    var availableServices: [Version:Service] { get }

}
extension Stellar {
    public static var category: AstralCategory{ .stellaire }
}

//public protocol ServiceStellaire: Stellar{
//    //Service
//    var availableServices:[Service] { get }
//
//    subscript(dynamicMember member: String)->Any { get set }
//}

////MARK: - protocol for custom service
public typealias Version = String

open class ServiceStellar: Stellar{
    public var name: String
    public var identifier: UUID
    public internal(set) var availableServices: [Version:Service] = [:]
    
    public init(name: String, identifier: UUID = UUID()) {
        self.identifier = identifier
        self.name = name
    }
    
    public func add(service: Service){
        self.availableServices[service.name] = service
    }
    
//    public func handle(activity: ServiceMethod, arguments: ServiceArgument)-> Result<Codable, Error>{
//        guard let service = self.availableServices[name] else {
//            return .failure(NebulaError.fail(message: "fail"))
//        }
////        let method = ServiceMethod(format: method)
//        return .success(service.handle(activity: activity, with: arguments))
//    }
}

extension ServiceStellar: AstralServerDelegatable{
    public final class ServerDelegate: MatterTransferServerDelegate{
        
        public typealias AstralType = ServiceStellar
        
        public let astral: AstralType
        
        public init(astral: AstralType) {
            self.astral = astral
        }
        
        public func server(didBind server: Server) {
            print("Stellar did bind: \(server.address)")
        }
        
        public func handle(context: ChannelHandlerContext, matter: CallMatter) throws -> Result<CallMatter.Reply, Error>? {
            guard  let service = self.astral.availableServices[matter.serviceName] else {
                return .failure(NebulaError.fail(message: "service [\(matter.serviceName)] not exists."))
            }
            
            let wrappedReturn = try service.perform(method: matter.methodName, with: matter.arguments)
            print("handle call matter:", matter, "result:", wrappedReturn)
            let replyBody = Call.ReplyBody.with { body in
                body.value = wrappedReturn.data ?? Data()
            }
            return .success(CallMatter.Reply(body: replyBody))
        }
    }
}

//extension ServiceStellar: AstralClientDelegatable{
//    public final class ClientDelegate: MatterTransferClientDelegate{
//        public init() {
//            
//        }
//        
////        public typealias AstralType = ServiceStellar
////        
////        public let astral: AstralType
////        
////        public init(astral: AstralType) {
////            self.astral = astral
////        }
//        
//    }
//}


public class StellarClientDelegate<T: Stellar>: MatterTransferClientDelegate{
    public typealias AstralType = T
    
    public var client: MatterTransferClient<AstralType>?
    
    public required init() {
        
    }
}
