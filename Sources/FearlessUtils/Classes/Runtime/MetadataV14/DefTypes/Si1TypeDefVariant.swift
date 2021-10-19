//
//  DefVariantMetadata.swift
//  FearlessUtilDemo
//
//  Created by li shuai on 2021/10/19.
//

import Foundation
public struct Si1Variant{
    public let name: String
    public let field: [Si1Field]
    public let index: UInt8
    public let docs: [String]
}
extension Si1Variant: ScaleCodable {
    public func encode(scaleEncoder: ScaleEncoding) throws {
        try self.name.encode(scaleEncoder: scaleEncoder)
        try self.field.encode(scaleEncoder: scaleEncoder)
        try self.index.encode(scaleEncoder: scaleEncoder)
        try self.docs.encode(scaleEncoder: scaleEncoder)
    }
    public init(scaleDecoder: ScaleDecoding) throws {
        self.name = try String(scaleDecoder: scaleDecoder)
        self.field = try [Si1Field](scaleDecoder: scaleDecoder)
        self.index = try UInt8(scaleDecoder: scaleDecoder)
        self.docs = try [String](scaleDecoder: scaleDecoder)
    }
}

public struct Si1TypeDefVariant{
    public let fields: [Si1Variant]
}
extension Si1TypeDefVariant: ScaleCodable {
    public func encode(scaleEncoder: ScaleEncoding) throws {
        try self.fields.encode(scaleEncoder: scaleEncoder)
    }
    public init(scaleDecoder: ScaleDecoding) throws {
        self.fields = try [Si1Variant](scaleDecoder: scaleDecoder)
    }
}
