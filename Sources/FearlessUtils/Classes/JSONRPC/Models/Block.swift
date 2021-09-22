import Foundation

public struct SignedBlock: Decodable {
    public let block: Block
    public let justification: Data?
    public init(block: Block,justification: Data?){
        self.block = block
        self.justification = justification
    }
}

public struct Block: Decodable {
    public struct Digest: Decodable {
        let logs: [String]
    }

    public  struct Header: Decodable {
        public let digest: Digest
        public let extrinsicsRoot: String
        public let number: String
        public let stateRoot: String
        public let parentHash: String
        public init(digest: Digest,extrinsicsRoot: String,number: String,stateRoot: String,parentHash: String){
            self.digest = digest
            self.extrinsicsRoot = extrinsicsRoot
            self.number = number
            self.stateRoot = stateRoot
            self.parentHash = parentHash
        }
    }

    public  let extrinsics: [String]
    public  let header: Header
}
