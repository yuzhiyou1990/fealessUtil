import Foundation

public struct JSONRPCInfo<P: Encodable>: Encodable {
    public enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case jsonrpc
        case method
        case params
    }

    public let identifier: UInt16
    public let jsonrpc: String
    public let method: String
    public let params: P
}
