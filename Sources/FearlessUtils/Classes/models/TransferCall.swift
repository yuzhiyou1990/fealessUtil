import Foundation

import BigInt

struct TransferCall: Codable {
    let dest: MultiAddress
    @StringCodable var value: BigUInt
}
struct AssetTransferCall: ScaleCodable {
    let receiver: Data
    let amount: BigUInt
    let currency_id: Data?
    init(receiver: Data, amount: BigUInt,currency_id: Data?) {
        self.receiver = receiver
        self.amount = amount
        self.currency_id = currency_id
    }

    init(scaleDecoder: ScaleDecoding) throws {
        receiver = try scaleDecoder.readAndConfirm(count: 32)
        currency_id = try scaleDecoder.readAndConfirm(count: 2)
        amount = try BigUInt(scaleDecoder: scaleDecoder)
    }

    func encode(scaleEncoder: ScaleEncoding) throws {
        scaleEncoder.appendRaw(data:try! Data(hexString: "0x00") )
        scaleEncoder.appendRaw(data: receiver)
        if let assetId = currency_id {
            scaleEncoder.appendRaw(data: assetId)
        }
        try amount.encode(scaleEncoder: scaleEncoder)
    }
}
