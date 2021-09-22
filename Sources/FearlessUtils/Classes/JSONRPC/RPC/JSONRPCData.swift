import Foundation

public struct JSONRPCError: Error, Decodable {
    public let message: String
    public let code: Int
}

public struct JSONRPCData<T: Decodable>: Decodable {
    public enum CodingKeys: String, CodingKey {
        case jsonrpc
        case result
        case error
        case identifier = "id"
    }

    public let jsonrpc: String
    public let result: T
    public let error: JSONRPCError?
    public let identifier: UInt16
}

public struct JSONRPCSubscriptionUpdate<T: Decodable>: Decodable {
    public struct Result: Decodable {
        let result: T
        let subscription: String
    }

    public  let jsonrpc: String
    public  let method: String
    public  let params: Result
}

public struct JSONRPCSubscriptionBasicUpdate: Decodable {
    public  struct Result: Decodable {
        let subscription: String
    }

    public let jsonrpc: String
    public let method: String
    public let params: Result
}

public struct JSONRPCBasicData: Decodable {
    public  enum CodingKeys: String, CodingKey {
        case jsonrpc
        case error
        case identifier = "id"
    }

    public let jsonrpc: String
    public let error: JSONRPCError?
    public let identifier: UInt16?
}
