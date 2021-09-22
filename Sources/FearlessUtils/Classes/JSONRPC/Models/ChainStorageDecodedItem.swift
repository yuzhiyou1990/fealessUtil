import Foundation
import RobinHood

public struct ChainStorageDecodedItem<T: Equatable & Decodable>: Equatable {
    public let identifier: String
    public let item: T?
}

public extension ChainStorageDecodedItem: Identifiable {}
