//
//  StorageMetadataV14.swift
//  FearlessUtilDemo
//
//  Created by li shuai on 2021/10/18.
//

import Foundation
public struct StorageEntryMetadataV14 {
    public let name: String
    public let modifier: StorageEntryModifier
    public let type: StorageEntryTypeV14
    public let defaultValue: Data
    public let documentation: [String]

    public init(name: String,
                modifier: StorageEntryModifier,
                type: StorageEntryTypeV14,
                defaultValue: Data,
                documentation: [String]) {
        self.name = name
        self.modifier = modifier
        self.type = type
        self.defaultValue = defaultValue
        self.documentation = documentation
    }
}

extension StorageEntryMetadataV14: ScaleCodable {
    public func encode(scaleEncoder: ScaleEncoding) throws {
        try name.encode(scaleEncoder: scaleEncoder)
        try modifier.encode(scaleEncoder: scaleEncoder)
        try type.encode(scaleEncoder: scaleEncoder)
        try defaultValue.encode(scaleEncoder: scaleEncoder)
        try documentation.encode(scaleEncoder: scaleEncoder)
    }

    public init(scaleDecoder: ScaleDecoding) throws {
        name = try String(scaleDecoder: scaleDecoder)
        modifier = try StorageEntryModifier(scaleDecoder: scaleDecoder)
        type = try StorageEntryTypeV14(scaleDecoder: scaleDecoder)
        defaultValue = try Data(scaleDecoder: scaleDecoder)
        documentation = try [String](scaleDecoder: scaleDecoder)
    }
}
public struct PalletStorageMetadataV14 {
    public let prefix: String
    public let items: [StorageEntryMetadataV14]
    public init(prefix: String, items: [StorageEntryMetadataV14]) {
        self.prefix = prefix
        self.items = items
    }
}
extension PalletStorageMetadataV14: ScaleCodable {
    public func encode(scaleEncoder: ScaleEncoding) throws {
        try prefix.encode(scaleEncoder: scaleEncoder)
        try items.encode(scaleEncoder: scaleEncoder)
    }

    public init(scaleDecoder: ScaleDecoding) throws {
        self.prefix = try String(scaleDecoder: scaleDecoder)
        items = try [StorageEntryMetadataV14](scaleDecoder: scaleDecoder)
    }
}
