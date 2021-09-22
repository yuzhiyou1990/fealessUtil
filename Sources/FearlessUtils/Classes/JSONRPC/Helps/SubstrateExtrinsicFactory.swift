import Foundation
import SubstrateKeychain
import BigInt

public protocol SubstarteExtrinsicFactoryProtocol {
    public static func transferExtrinsic(from senderAccountId: Data,
                                  transferCall: ScaleCodable?,
                                  tip: BigUInt?,
                                  additionalParameters: SubstrateExtrinsicParameters,
                                  signer: @escaping (Data) throws -> Data) throws -> Data
}

public struct SubstrateExtrinsicParameters {
    public  let nonce: UInt32
    public  let genesisHash: Data
    public  let specVersion: UInt32
    public  let transactionVersion: UInt32
    public  let signatureVersion: UInt8
    public  let moduleIndex: UInt8
    public  let callIndex: UInt8
    public  let tip: BigUInt?
}

public struct SubstrateExtrinsicFactory: SubstarteExtrinsicFactoryProtocol {
    public  static let extrinsicVersion: UInt8 = 132

    public static func transferExtrinsic(from senderAccountId: Data,
                                  transferCall: ScaleCodable?,
                                  tip: BigUInt? = 0,
                                  additionalParameters: SubstrateExtrinsicParameters,
                                  signer: @escaping (Data) throws -> Data) throws -> Data {
        let callEncoder = ScaleEncoder()
        try transferCall?.encode(scaleEncoder: callEncoder)
        let callArguments = callEncoder.encode()

        let call = Call(moduleIndex: additionalParameters.moduleIndex,
                        callIndex: additionalParameters.callIndex,
                        arguments: callArguments)

        let era = Era.immortal
        let payload = ExtrinsicPayload(call: call,
                                       era: era,
                                       nonce: additionalParameters.nonce,
                                       tip: tip!,
                                       specVersion: additionalParameters.specVersion,
                                       transactionVersion: additionalParameters.transactionVersion,
                                       genesisHash: additionalParameters.genesisHash,
                                       blockHash: additionalParameters.genesisHash)

        let payloadEncoder = ScaleEncoder()
        try payload.encode(scaleEncoder: payloadEncoder)

        let payloadData = payloadEncoder.encode()

        let signature = try signer(payloadData)

        let transaction = ExtrinsicTransaction(accountId: senderAccountId,
                                      signatureVersion: additionalParameters.signatureVersion,
                                      signature: signature,
                                      era: era,
                                      nonce: additionalParameters.nonce,
                                      tip: tip!)

        let extrinsic = ExtrinsicAsset(version: Self.extrinsicVersion,
                                  transaction: transaction,
                                  call: call)

        let extrinsicCoder = ScaleEncoder()
        try extrinsic.encode(scaleEncoder: extrinsicCoder)

        return extrinsicCoder.encode()
    }
}
