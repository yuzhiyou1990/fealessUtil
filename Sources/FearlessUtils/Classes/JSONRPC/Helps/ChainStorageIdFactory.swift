import Foundation

public protocol ChainStorageIdFactoryProtocol {
      func createIdentifier(for key: Data) -> String
}

public final class ChainStorageIdFactory: ChainStorageIdFactoryProtocol {
    public  let genesisData: Data

    public init(chain: SubstrateChain) throws {
        genesisData = try Data(hexString: chain.genesisHash ?? "")
    }

    public  func createIdentifier(for key: Data) -> String {
        (genesisData.prefix(7) + key).toHex()
    }
}
