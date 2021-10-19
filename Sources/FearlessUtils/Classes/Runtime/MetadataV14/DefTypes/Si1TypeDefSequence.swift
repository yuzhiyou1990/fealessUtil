//
//  Si1TypeDefSequence.swift
//  FearlessUtilDemo
//
//  Created by li shuai on 2021/10/19.
//

import Foundation
import BigInt

public struct Si1TypeDefSequence{
    public let type: BigUInt
}

extension Si1TypeDefSequence: ScaleCodable {
    public func encode(scaleEncoder: ScaleEncoding) throws {
        try self.type.encode(scaleEncoder: scaleEncoder)
    }
    public init(scaleDecoder: ScaleDecoding) throws {
        self.type = try BigUInt(scaleDecoder: scaleDecoder)
    }
}
