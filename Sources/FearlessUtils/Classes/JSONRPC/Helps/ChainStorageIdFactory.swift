import Foundation

public protocol ChainStorageIdFactoryProtocol {
    func createIdentifier(for key: Data) -> String
}

public final class ChainStorageIdFactory: ChainStorageIdFactoryProtocol {
    let genesisData: Data

    init(chain: SubstrateChain) throws {
        genesisData = try Data(hexString: chain.genesisHash)
    }

    func createIdentifier(for key: Data) -> String {
        (genesisData.prefix(7) + key).toHex()
    }
}
