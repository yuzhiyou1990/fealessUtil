//
//  ExtrinsicMetadataV14.swift
//  FearlessUtilDemo
//
//  Created by li shuai on 2021/10/19.
//

import Foundation
import BigInt
public struct SignedExtensionMetadataV14{
    public let identifier:String
    public let type: BigUInt
    public let additionalSigned: BigUInt
}
extension SignedExtensionMetadataV14: ScaleCodable {
    public func encode(scaleEncoder: ScaleEncoding) throws {
        try identifier.encode(scaleEncoder: scaleEncoder)
        try type.encode(scaleEncoder: scaleEncoder)
        try additionalSigned.encode(scaleEncoder: scaleEncoder)
    }

    public init(scaleDecoder: ScaleDecoding) throws {
        self.identifier = try String(scaleDecoder: scaleDecoder)
        self.type = try BigUInt(scaleDecoder: scaleDecoder)
        self.additionalSigned = try BigUInt(scaleDecoder: scaleDecoder)
    }
}

public struct ExtrinsicMetadataV14{
    public let type:BigUInt
    public let version: UInt8
    public let signedExtensions: [SignedExtensionMetadataV14]
}
extension ExtrinsicMetadataV14: ScaleCodable {
    public func encode(scaleEncoder: ScaleEncoding) throws {
        try type.encode(scaleEncoder: scaleEncoder)
        try version.encode(scaleEncoder: scaleEncoder)
    }

    public init(scaleDecoder: ScaleDecoding) throws {
        self.type = try BigUInt(scaleDecoder: scaleDecoder)
        self.version = try UInt8(scaleDecoder: scaleDecoder)
        self.signedExtensions = try [SignedExtensionMetadataV14](scaleDecoder: scaleDecoder)
    }
}
