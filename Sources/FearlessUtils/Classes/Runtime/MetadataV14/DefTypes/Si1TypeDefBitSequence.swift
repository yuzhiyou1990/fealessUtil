//
//  Si1TypeDefBitSequence.swift
//  FearlessUtilDemo
//
//  Created by li shuai on 2021/10/19.
//

import Foundation
import BigInt

public struct Si1TypeDefBitSequence{
    public let bitStoreType: BigUInt
    public let bitOrderType: BigUInt
}
extension Si1TypeDefBitSequence: ScaleCodable {
    public func encode(scaleEncoder: ScaleEncoding) throws {
        try self.bitStoreType.encode(scaleEncoder: scaleEncoder)
        try self.bitOrderType.encode(scaleEncoder: scaleEncoder)
    }
    public init(scaleDecoder: ScaleDecoding) throws {
        self.bitStoreType = try BigUInt(scaleDecoder: scaleDecoder)
        self.bitOrderType = try BigUInt(scaleDecoder: scaleDecoder)
    }
}
