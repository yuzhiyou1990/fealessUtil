import Foundation

import BigInt

public struct TransferCall: Codable {
    public  let dest: MultiAddress
    @StringCodable public var value: BigUInt
    public init(dest: MultiAddress,value: BigUInt){
        self.dest = dest
        self.value = value
    }
}
