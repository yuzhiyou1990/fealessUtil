import Foundation

import BigInt

public struct TransferCall: Codable {
    public  let dest: MultiAddress
    public @StringCodable var value: BigUInt
}
public struct AssetTransferCall: ScaleCodable {
    public let receiver: Data
    public let amount: BigUInt
    public let currency_id: Data?
    public init(receiver: Data, amount: BigUInt,currency_id: Data?) {
        self.receiver = receiver
        self.amount = amount
        self.currency_id = currency_id
    }

    public init(scaleDecoder: ScaleDecoding) throws {
        receiver = try scaleDecoder.readAndConfirm(count: 32)
        currency_id = try scaleDecoder.readAndConfirm(count: 2)
        amount = try BigUInt(scaleDecoder: scaleDecoder)
    }

    public func encode(scaleEncoder: ScaleEncoding) throws {
        scaleEncoder.appendRaw(data:try! Data(hexString: "0x00") )
        scaleEncoder.appendRaw(data: receiver)
        if let assetId = currency_id {
            scaleEncoder.appendRaw(data: assetId)
        }
        try amount.encode(scaleEncoder: scaleEncoder)
    }
}
