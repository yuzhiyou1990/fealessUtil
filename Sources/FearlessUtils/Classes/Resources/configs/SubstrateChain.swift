import Foundation

struct SubstrateChain {
    enum ChainNetError {
        case genesisHashError
    }
    var genesisHash: String
    var chainName: String
   
} 
