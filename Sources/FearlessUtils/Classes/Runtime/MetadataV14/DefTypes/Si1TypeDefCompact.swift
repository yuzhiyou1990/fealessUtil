//
//  Si1TypeDefCompact.swift
//  FearlessUtilDemo
//
//  Created by li shuai on 2021/10/19.
//

import Foundation
import BigInt

public struct Si1TypeDefCompact{
    public let type: BigUInt
}

extension Si1TypeDefCompact: ScaleCodable {
    public func encode(scaleEncoder: ScaleEncoding) throws {
        try self.type.encode(scaleEncoder: scaleEncoder)
    }
    public init(scaleDecoder: ScaleDecoding) throws {
        self.type = try BigUInt(scaleDecoder: scaleDecoder)
    }
}
