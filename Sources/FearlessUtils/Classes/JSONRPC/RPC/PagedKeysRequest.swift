import Foundation

public struct PagedKeysRequest: Encodable {
    public  let key: String
    public let count: UInt32
    public let offset: String?

    public init(key: String, count: UInt32 = 1000, offset: String? = nil) {
        self.key = key
        self.count = count
        self.offset = offset
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(key)
        try container.encode(count)

        if let offset = offset {
            try container.encode(offset)
        }
    }
}
