import Foundation

import RobinHood

public enum StorageDecodingOperationError: Error {
    public  case missingRequiredParams
    public case invalidStoragePath
}

public protocol StorageDecodable {
    public  func decode(data: Data, path: StorageCodingPath, codingFactory: RuntimeCoderFactoryProtocol) throws -> JSON
}

public extension StorageDecodable {
    public func decode(data: Data, path: StorageCodingPath, codingFactory: RuntimeCoderFactoryProtocol) throws -> JSON {
        guard let entry = codingFactory.metadata.getStorageMetadata(
            in: path.moduleName,
            storageName: path.itemName
        ) else {
            throw StorageDecodingOperationError.invalidStoragePath
        }

        let decoder = try codingFactory.createDecoder(from: data)
        return try decoder.read(type: entry.type.typeName)
    }
}

public protocol StorageModifierHandling {
    public func handleModifier(at path: StorageCodingPath, codingFactory: RuntimeCoderFactoryProtocol) throws -> JSON?
}

public extension StorageModifierHandling {
    public  func handleModifier(at path: StorageCodingPath, codingFactory: RuntimeCoderFactoryProtocol) throws -> JSON? {
        guard let entry = codingFactory.metadata.getStorageMetadata(
            in: path.moduleName,
            storageName: path.itemName
        ) else {
            throw StorageDecodingOperationError.invalidStoragePath
        }

        switch entry.modifier {
        case .defaultModifier:
            let decoder = try codingFactory.createDecoder(from: entry.defaultValue)
            return try decoder.read(type: entry.type.typeName)
        case .optional:
            return nil
        }
    }
}

public final class StorageDecodingOperation<T: Decodable>: BaseOperation<T>, StorageDecodable {
    public var data: Data?
    public  var codingFactory: RuntimeCoderFactoryProtocol?

    public  let path: StorageCodingPath

    public init(path: StorageCodingPath, data: Data? = nil) {
        self.path = path
        self.data = data

        super.init()
    }

    override func main() {
        super.main()

        if isCancelled {
            return
        }

        if result != nil {
            return
        }

        do {
            guard let data = data, let factory = codingFactory else {
                throw StorageDecodingOperationError.missingRequiredParams
            }

            let item = try decode(data: data, path: path, codingFactory: factory).map(to: T.self)
            result = .success(item)
        } catch {
            result = .failure(error)
        }
    }
}

public final class StorageFallbackDecodingOperation<T: Decodable>: BaseOperation<T?>,
    StorageDecodable, StorageModifierHandling {
    public  var data: Data?
    public  var codingFactory: RuntimeCoderFactoryProtocol?

    public  let path: StorageCodingPath

    public   init(path: StorageCodingPath, data: Data? = nil) {
        self.path = path
        self.data = data

        super.init()
    }

    override func main() {
        super.main()

        if isCancelled {
            return
        }

        if result != nil {
            return
        }

        do {
            guard let factory = codingFactory else {
                throw StorageDecodingOperationError.missingRequiredParams
            }

            if let data = data {
                let item = try decode(data: data, path: path, codingFactory: factory).map(to: T.self)
                result = .success(item)
            } else {
                let item = try handleModifier(at: path, codingFactory: factory)?.map(to: T.self)
                result = .success(item)
            }

        } catch {
            result = .failure(error)
        }
    }
}

public final class StorageDecodingListOperation<T: Decodable>: BaseOperation<[T]>, StorageDecodable {
    public  var dataList: [Data]?
    public var codingFactory: RuntimeCoderFactoryProtocol?

    public  let path: StorageCodingPath

    public  init(path: StorageCodingPath, dataList: [Data]? = nil) {
        self.path = path
        self.dataList = dataList

        super.init()
    }

    override func main() {
        super.main()

        if isCancelled {
            return
        }

        if result != nil {
            return
        }

        do {
            guard let dataList = dataList, let factory = codingFactory else {
                throw StorageDecodingOperationError.missingRequiredParams
            }

            let items: [T] = try dataList.map { try decode(data: $0, path: path, codingFactory: factory)
                .map(to: T.self)
            }

            result = .success(items)
        } catch {
            result = .failure(error)
        }
    }
}

public final class StorageFallbackDecodingListOperation<T: Decodable>: BaseOperation<[T?]>,
    StorageDecodable, StorageModifierHandling {
    public var dataList: [Data?]?
    public  var codingFactory: RuntimeCoderFactoryProtocol?

    public  let path: StorageCodingPath

    public init(path: StorageCodingPath, dataList: [Data?]? = nil) {
        self.path = path
        self.dataList = dataList

        super.init()
    }

    override func main() {
        super.main()

        if isCancelled {
            return
        }

        if result != nil {
            return
        }

        do {
            guard let dataList = dataList, let factory = codingFactory else {
                throw StorageDecodingOperationError.missingRequiredParams
            }

            let items: [T?] = try dataList.map { data in
                if let data = data {
                    return try decode(data: data, path: path, codingFactory: factory).map(to: T.self)
                } else {
                    return try handleModifier(at: path, codingFactory: factory)?.map(to: T.self)
                }
            }

            result = .success(items)
        } catch {
            result = .failure(error)
        }
    }
}

public protocol ConstantDecodable {
    public  func decode(at path: ConstantCodingPath, codingFactory: RuntimeCoderFactoryProtocol) throws -> JSON
}

public extension ConstantDecodable {
    public func decode(at path: ConstantCodingPath, codingFactory: RuntimeCoderFactoryProtocol) throws -> JSON {
        guard let entry = codingFactory.metadata
            .getConstant(in: path.moduleName, constantName: path.constantName) else {
            throw StorageDecodingOperationError.invalidStoragePath
        }

        let decoder = try codingFactory.createDecoder(from: entry.value)
        return try decoder.read(type: entry.type)
    }
}

public final class StorageConstantOperation<T: Decodable>: BaseOperation<T>, ConstantDecodable {
    public  var codingFactory: RuntimeCoderFactoryProtocol?

    public  let path: ConstantCodingPath

    public  init(path: ConstantCodingPath) {
        self.path = path

        super.init()
    }

    override func main() {
        super.main()

        if isCancelled {
            return
        }

        if result != nil {
            return
        }

        do {
            guard let factory = codingFactory else {
                throw StorageDecodingOperationError.missingRequiredParams
            }

            let item: T = try decode(at: path, codingFactory: factory).map(to: T.self)
            result = .success(item)
        } catch {
            result = .failure(error)
        }
    }
}

public final class PrimitiveConstantOperation<T: LosslessStringConvertible & Equatable>: BaseOperation<T>, ConstantDecodable {
    public var codingFactory: RuntimeCoderFactoryProtocol?

    public  let path: ConstantCodingPath

    public init(path: ConstantCodingPath) {
        self.path = path

        super.init()
    }

    override func main() {
        super.main()

        if isCancelled {
            return
        }

        if result != nil {
            return
        }

        do {
            guard let factory = codingFactory else {
                throw StorageDecodingOperationError.missingRequiredParams
            }

            let item: StringScaleMapper<T> = try decode(at: path, codingFactory: factory)
                .map(to: StringScaleMapper<T>.self)
            result = .success(item.value)
        } catch {
            result = .failure(error)
        }
    }
}
