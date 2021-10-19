//
//  PalletsMetadata.swift
//  FearlessUtilDemo
//
//  Created by li shuai on 2021/10/18.
//

import Foundation
import BigInt
public struct PalletConstantMetadataV14 {
    public let name: String
    public let type: BigUInt
    public let value: Data
    public let documentation: [String]
}
extension PalletConstantMetadataV14: ScaleCodable {
    public func encode(scaleEncoder: ScaleEncoding) throws {
        try name.encode(scaleEncoder: scaleEncoder)
        try type.encode(scaleEncoder: scaleEncoder)
        try value.encode(scaleEncoder: scaleEncoder)
        try documentation.encode(scaleEncoder: scaleEncoder)
    }

    public init(scaleDecoder: ScaleDecoding) throws {
        name = try String(scaleDecoder: scaleDecoder)
        type = try BigUInt(scaleDecoder: scaleDecoder)
        value = try Data(scaleDecoder: scaleDecoder)
        documentation = try [String](scaleDecoder: scaleDecoder)
    }
}
public struct PalletMetadataV14 {
    public let name: String
    public let storage: PalletStorageMetadataV14?
    public let calls: MetadataType?
    public let events: MetadataType?
    public let constants: [PalletConstantMetadataV14]
    public let errors: ScaleOption<MetadataType>
    public let index: UInt8
}
extension PalletMetadataV14: ScaleCodable {
    public func encode(scaleEncoder: ScaleEncoding) throws {
        try name.encode(scaleEncoder: scaleEncoder)
        try ScaleOption(value: storage).encode(scaleEncoder: scaleEncoder)
        try ScaleOption(value: calls).encode(scaleEncoder: scaleEncoder)
        try ScaleOption(value: events).encode(scaleEncoder: scaleEncoder)
        try constants.encode(scaleEncoder: scaleEncoder)
        try errors.encode(scaleEncoder: scaleEncoder)
        try index.encode(scaleEncoder: scaleEncoder)
    }

    public init(scaleDecoder: ScaleDecoding) throws {
        name = try String(scaleDecoder: scaleDecoder)
        storage = try ScaleOption(scaleDecoder: scaleDecoder).value
        calls = try ScaleOption(scaleDecoder: scaleDecoder).value
        events = try ScaleOption(scaleDecoder: scaleDecoder).value
        constants = try [PalletConstantMetadataV14](scaleDecoder: scaleDecoder)
        errors = try ScaleOption<MetadataType>(scaleDecoder: scaleDecoder)
        index = try UInt8(scaleDecoder: scaleDecoder)
    }
}
