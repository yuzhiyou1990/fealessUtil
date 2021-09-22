import Foundation
import RobinHood

public struct ChainStorageDecodedItem<T: Equatable & Decodable>: Equatable {
    let identifier: String
    let item: T?
}

public extension ChainStorageDecodedItem: Identifiable {}
