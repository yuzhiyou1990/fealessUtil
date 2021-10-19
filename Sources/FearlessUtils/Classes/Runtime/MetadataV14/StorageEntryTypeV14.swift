//
//  StorageEntryTypeV14.swift
//  FearlessUtilDemo
//
//  Created by li shuai on 2021/10/18.
//

import Foundation
import BigInt

public enum StorageEntryTypeV14 {
    case plain(_ value: BigUInt)
    case map(_ value: MapEntryV14)
}
extension StorageEntryTypeV14: ScaleCodable {
    public func encode(scaleEncoder: ScaleEncoding) throws {
        switch self {
        case .plain(let value):
            try UInt8(0).encode(scaleEncoder: scaleEncoder)
            try value.encode(scaleEncoder: scaleEncoder)
        case .map(let value):
            try UInt8(1).encode(scaleEncoder: scaleEncoder)
            try value.encode(scaleEncoder: scaleEncoder)
        }
    }

    public init(scaleDecoder: ScaleDecoding) throws {
        let rawValue = try UInt8(scaleDecoder: scaleDecoder)

        switch rawValue {
        case 0:
            let value = try BigUInt(scaleDecoder: scaleDecoder)
            self = .plain(value)
        case 1:
            let value = try MapEntryV14(scaleDecoder: scaleDecoder)
            self = .map(value)
        default:
            throw ScaleCodingError.unexpectedDecodedValue
        }
    }
}

public struct MapEntryV14 {
    public let hasher: [StorageHasher]
    public let key: BigUInt
    public let value: BigUInt
    public init(hasher: [StorageHasher], key: BigUInt, value: BigUInt) {
        self.hasher = hasher
        self.key = key
        self.value = value
    }
}
extension MapEntryV14: ScaleCodable {
    public func encode(scaleEncoder: ScaleEncoding) throws {
        try hasher.encode(scaleEncoder: scaleEncoder)
        try key.encode(scaleEncoder: scaleEncoder)
        try value.encode(scaleEncoder: scaleEncoder)
    }

    public init(scaleDecoder: ScaleDecoding) throws {
        hasher = try [StorageHasher](scaleDecoder: scaleDecoder)
        key = try BigUInt(scaleDecoder: scaleDecoder)
        value = try BigUInt(scaleDecoder: scaleDecoder)
    }
}
