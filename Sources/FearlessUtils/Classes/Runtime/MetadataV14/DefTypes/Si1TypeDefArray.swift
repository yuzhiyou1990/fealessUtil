//
//  DefArrayMetadata.swift
//  FearlessUtilDemo
//
//  Created by li shuai on 2021/10/19.
//

import Foundation
import BigInt
/////////////////////////////////

public struct Si1TypeDefArray{
    public let len: UInt32
    public let type: BigUInt
}
extension Si1TypeDefArray: ScaleCodable {
    public func encode(scaleEncoder: ScaleEncoding) throws {
        try self.len.encode(scaleEncoder: scaleEncoder)
        try self.type.encode(scaleEncoder: scaleEncoder)
    }
    public init(scaleDecoder: ScaleDecoding) throws {
        self.len = try UInt32(scaleDecoder: scaleDecoder)
        self.type = try BigUInt(scaleDecoder: scaleDecoder)
    }
}
