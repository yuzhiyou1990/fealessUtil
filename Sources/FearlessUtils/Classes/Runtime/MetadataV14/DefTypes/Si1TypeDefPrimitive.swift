//
//  Si0TypeDefPrimitive.swift
//  FearlessUtilDemo
//
//  Created by li shuai on 2021/10/19.
//

import Foundation

public enum Si0TypeDefPrimitive: UInt8, CaseIterable {
    case bool
    case char
    case str
    case u8
    case u16
    case u32
    case u64
    case u128
    case i8
    case i16
    case i32
    case i64
    case i128
    public var name: UInt8 { rawValue }
}

public struct Si1TypeDefPrimitive{
    public var  primitive:Si0TypeDefPrimitive?
}
extension Si1TypeDefPrimitive: ScaleCodable {
    public func encode(scaleEncoder: ScaleEncoding) throws {
        try self.primitive?.rawValue.encode(scaleEncoder: scaleEncoder)
    }
    public init(scaleDecoder: ScaleDecoding) throws {
        let name = try UInt8(scaleDecoder: scaleDecoder)
        self.primitive = Si0TypeDefPrimitive(rawValue: name)
    }
}
