import Foundation
import BigInt

public struct ExtrinsicAssetConstants {
    public static let signedExtrinsicInitialVersion: UInt8 = 128
    public static let accountIdLength: UInt8 = 32
}

public struct Call {
    public let moduleIndex: UInt8
    public let callIndex: UInt8
    public let arguments: Data?
}

public enum ExtrinsicCodingError: Error {
    case unsupportedSignatureVersion
}

public struct ExtrinsicAsset: ScaleCodable {
    public let version: UInt8
    public  let transaction: ExtrinsicTransaction?
    public  let call: Call
    public  init(version: UInt8, transaction: ExtrinsicTransaction?, call: Call) {
        self.version = version
        self.transaction = transaction
        self.call = call
    }

    public init(scaleDecoder: ScaleDecoding) throws {
        let lengthValue = try BigUInt(scaleDecoder: scaleDecoder)
        let extrinsicLength = Int(lengthValue)

        let extrinsicData = try scaleDecoder.read(count: extrinsicLength)
        try scaleDecoder.confirm(count: extrinsicLength)

        let internalDecoder = try ScaleDecoder(data: extrinsicData)
        version = try UInt8(scaleDecoder: internalDecoder)

        if version >= ExtrinsicAssetConstants.signedExtrinsicInitialVersion {
            transaction = try ExtrinsicTransaction(scaleDecoder: internalDecoder)
        } else {
            transaction = nil
        }

        let moduleIndex = try UInt8(scaleDecoder: internalDecoder)
        let callIndex = try UInt8(scaleDecoder: internalDecoder)

        let arguments: Data?

        if internalDecoder.remained > 0 {
            arguments = try internalDecoder.read(count: internalDecoder.remained)
            try internalDecoder.confirm(count: internalDecoder.remained)
        } else {
            arguments = nil
        }

        call = Call(moduleIndex: moduleIndex, callIndex: callIndex, arguments: arguments)
    }

    public func encode(scaleEncoder: ScaleEncoding) throws {
        let internalEncoder = ScaleEncoder()
        try version.encode(scaleEncoder: internalEncoder)
        try transaction?.encode(scaleEncoder: internalEncoder)
        try call.moduleIndex.encode(scaleEncoder: internalEncoder)
        try call.callIndex.encode(scaleEncoder: internalEncoder)

        if let arguments = call.arguments {
            internalEncoder.appendRaw(data: arguments)
        }

        let encodedData = internalEncoder.encode()
        let encodedLength = BigUInt(encodedData.count)

        try encodedLength.encode(scaleEncoder: scaleEncoder)
        scaleEncoder.appendRaw(data: encodedData)
    }
}

public struct ExtrinsicTransaction: ScaleCodable {
    public let accountId: Data
    public  let signatureVersion: UInt8
    public  let signature: Data
    public let era: Era
    public let nonce: UInt32
    public  let tip: BigUInt

    public init(accountId: Data,
         signatureVersion: UInt8,
         signature: Data,
         era: Era,
         nonce: UInt32,
         tip: BigUInt) {
        self.accountId = accountId
        self.signatureVersion = signatureVersion
        self.signature = signature
        self.era = era
        self.nonce = nonce
        self.tip = tip
    }

    public init(scaleDecoder: ScaleDecoding) throws {
        accountId = try scaleDecoder.readAndConfirm(count: Int(ExtrinsicAssetConstants.accountIdLength))
        signatureVersion = try UInt8(scaleDecoder: scaleDecoder)

        guard let cryptoType = CryptoType(version: signatureVersion) else {
            throw ExtrinsicCodingError.unsupportedSignatureVersion
        }

        signature = try scaleDecoder.readAndConfirm(count: cryptoType.signatureLength)

        era = try Era(scaleDecoder: scaleDecoder)

        let nonceValue = try BigUInt(scaleDecoder: scaleDecoder)
        nonce = UInt32(nonceValue)

        tip = try BigUInt(scaleDecoder: scaleDecoder)
    }

    public func encode(scaleEncoder: ScaleEncoding) throws {
        scaleEncoder.appendRaw(data:try! Data(hexString: "0x00") )
        scaleEncoder.appendRaw(data: accountId)
        try signatureVersion.encode(scaleEncoder: scaleEncoder)
        scaleEncoder.appendRaw(data: signature)
        try era.encode(scaleEncoder: scaleEncoder)
        try BigUInt(nonce).encode(scaleEncoder: scaleEncoder)
        try tip.encode(scaleEncoder: scaleEncoder)
    }
}

public struct ExtrinsicPayload: ScaleEncodable {
    public let call: Call
    public let era: Era
    public let nonce: UInt32
    public let tip: BigUInt
    public let specVersion: UInt32
    public let transactionVersion: UInt32
    public let genesisHash: Data
    public let blockHash: Data

    public func encode(scaleEncoder: ScaleEncoding) throws {
        try call.moduleIndex.encode(scaleEncoder: scaleEncoder)
        try call.callIndex.encode(scaleEncoder: scaleEncoder)

        if let arguments = call.arguments {
            scaleEncoder.appendRaw(data: arguments)
        }

        try era.encode(scaleEncoder: scaleEncoder)
        try BigUInt(nonce).encode(scaleEncoder: scaleEncoder)
        try tip.encode(scaleEncoder: scaleEncoder)
        try specVersion.encode(scaleEncoder: scaleEncoder)
        try transactionVersion.encode(scaleEncoder: scaleEncoder)
        scaleEncoder.appendRaw(data: genesisHash)
        scaleEncoder.appendRaw(data: blockHash)
    }
}
