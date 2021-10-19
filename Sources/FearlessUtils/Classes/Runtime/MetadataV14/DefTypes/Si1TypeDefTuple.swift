//
//  Si1TypeDefTuple.swift
//  FearlessUtilDemo
//
//  Created by li shuai on 2021/10/19.
//

import Foundation
import BigInt

public struct Si1TypeDefTuple{
    public let tuple: [BigUInt]
}

extension Si1TypeDefTuple: ScaleCodable {
    public func encode(scaleEncoder: ScaleEncoding) throws {
        try self.tuple.encode(scaleEncoder: scaleEncoder)
    }
    public init(scaleDecoder: ScaleDecoding) throws {
        self.tuple = try [BigUInt](scaleDecoder: scaleDecoder)
    }
}
