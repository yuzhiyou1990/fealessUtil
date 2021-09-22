import Foundation

public struct JSONRPCError: Error, Decodable {
    let message: String
    let code: Int
}

public struct JSONRPCData<T: Decodable>: Decodable {
    enum CodingKeys: String, CodingKey {
        case jsonrpc
        case result
        case error
        case identifier = "id"
    }

    let jsonrpc: String
    let result: T
    let error: JSONRPCError?
    let identifier: UInt16
}

public struct JSONRPCSubscriptionUpdate<T: Decodable>: Decodable {
    struct Result: Decodable {
        let result: T
        let subscription: String
    }

    let jsonrpc: String
    let method: String
    let params: Result
}

public struct JSONRPCSubscriptionBasicUpdate: Decodable {
    struct Result: Decodable {
        let subscription: String
    }

    let jsonrpc: String
    let method: String
    let params: Result
}

public struct JSONRPCBasicData: Decodable {
    enum CodingKeys: String, CodingKey {
        case jsonrpc
        case error
        case identifier = "id"
    }

    let jsonrpc: String
    let error: JSONRPCError?
    let identifier: UInt16?
}
