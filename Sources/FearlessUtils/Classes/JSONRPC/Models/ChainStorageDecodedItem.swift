import Foundation
import RobinHood

public struct ChainStorageDecodedItem<T: Equatable & Decodable>: Equatable {
    public let identifier: String
    public let item: T?
}

extension ChainStorageDecodedItem: Identifiable {}
