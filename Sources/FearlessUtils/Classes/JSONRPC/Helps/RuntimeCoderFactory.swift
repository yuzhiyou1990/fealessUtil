import Foundation

public protocol RuntimeCoderFactoryProtocol {
    public var specVersion: UInt32 { get }
    public var txVersion: UInt32 { get }
    public var metadata: RuntimeMetadata { get }

    public func createEncoder() -> DynamicScaleEncoding
    public func createDecoder(from data: Data) throws -> DynamicScaleDecoding
}

public final  class RuntimeCoderFactory: RuntimeCoderFactoryProtocol {
    public  let catalog: TypeRegistryCatalogProtocol
    public  let specVersion: UInt32
    public  let txVersion: UInt32
    public let metadata: RuntimeMetadata

    public init(
        catalog: TypeRegistryCatalogProtocol,
        specVersion: UInt32,
        txVersion: UInt32,
        metadata: RuntimeMetadata
    ) {
        self.catalog = catalog
        self.specVersion = specVersion
        self.txVersion = txVersion
        self.metadata = metadata
    }

    public  func createEncoder() -> DynamicScaleEncoding {
        DynamicScaleEncoder(registry: catalog, version: UInt64(specVersion))
    }

    public func createDecoder(from data: Data) throws -> DynamicScaleDecoding {
        try DynamicScaleDecoder(data: data, registry: catalog, version: UInt64(specVersion))
    }
}
