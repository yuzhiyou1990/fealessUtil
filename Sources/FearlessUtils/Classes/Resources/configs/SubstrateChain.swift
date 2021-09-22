import Foundation

public struct SubstrateChain {
    public enum ChainNetError {
        case genesisHashError
    }
    public var genesisHash: String
    public var chainName: String
   
} 
