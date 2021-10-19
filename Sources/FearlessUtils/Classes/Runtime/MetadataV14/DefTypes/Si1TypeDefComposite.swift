//
//  DefTypes.swift
//  FearlessUtilDemo
//
//  Created by li shuai on 2021/10/19.
//

import Foundation
import BigInt

public struct Si1Field{
    public let name:ScaleOption<String>
    public let type:BigUInt
    public let typeName: ScaleOption<String>
    public let docs:[String]
}
extension Si1Field: ScaleCodable {
    public func encode(scaleEncoder: ScaleEncoding) throws {
        try self.name.encode(scaleEncoder: scaleEncoder)
        try self.type.encode(scaleEncoder: scaleEncoder)
        try self.typeName.encode(scaleEncoder: scaleEncoder)
        try self.docs.encode(scaleEncoder: scaleEncoder)
    }
    public init(scaleDecoder: ScaleDecoding) throws {
        self.name = try ScaleOption<String>(scaleDecoder: scaleDecoder)
        self.type = try BigUInt(scaleDecoder: scaleDecoder)
        self.typeName = try ScaleOption<String>(scaleDecoder: scaleDecoder)
        self.docs = try [String](scaleDecoder: scaleDecoder)
    }
}

public struct Si1TypeDefComposite{
    public let fields: [Si1Field]
}
extension Si1TypeDefComposite: ScaleCodable {
    public func encode(scaleEncoder: ScaleEncoding) throws {
        try self.fields.encode(scaleEncoder: scaleEncoder)
    }
    public init(scaleDecoder: ScaleDecoding) throws {
        self.fields = try [Si1Field](scaleDecoder: scaleDecoder)
    }
}
