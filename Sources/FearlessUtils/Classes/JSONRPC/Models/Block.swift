import Foundation

public struct SignedBlock: Decodable {
    public let block: Block
    public let justification: Data?
}

public struct Block: Decodable {
    public struct Digest: Decodable {
        let logs: [String]
    }

    public  struct Header: Decodable {
        let digest: Digest
        let extrinsicsRoot: String
        let number: String
        let stateRoot: String
        let parentHash: String
    }

    public  let extrinsics: [String]
    public  let header: Header
}
