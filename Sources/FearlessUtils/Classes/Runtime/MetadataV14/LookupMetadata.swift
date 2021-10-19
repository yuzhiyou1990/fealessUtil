//
//  LookupMetadata.swift
//  FearlessUtilDemo
//
//  Created by li shuai on 2021/10/18.
//

import Foundation
import BigInt
public enum Si1TypeDefEnum{
    case composite(compositeMetadata:Si1TypeDefComposite)
    case variant(si1TypeDefVariant:Si1TypeDefVariant)
    case sequence(si1TypeDefSequence:Si1TypeDefSequence)
    case array(defArrayMetadata:Si1TypeDefArray)
    case tuple(si1TypeDefTuple:Si1TypeDefTuple)
    case primitive(si1TypeDefPrimitive:Si1TypeDefPrimitive)
    case compact(si1TypeDefCompact:Si1TypeDefCompact)
    case bitSequence(si1TypeDefBitSequence:Si1TypeDefBitSequence)
    case historicMetaCompat(type:String)
}
public struct Si1TypeDef{
    var si1TypeDefEnum:Si1TypeDefEnum?
}
extension Si1TypeDef: ScaleCodable {
    public func encode(scaleEncoder: ScaleEncoding) throws {

    }
    public init(scaleDecoder: ScaleDecoding) throws {
        let rawValue = try UInt8(scaleDecoder: scaleDecoder)
        //isComposite
        if rawValue == 0 {
            self.si1TypeDefEnum = .composite(compositeMetadata: try Si1TypeDefComposite(scaleDecoder: scaleDecoder))
        }
        //isVariant
        else if rawValue == 1{
            self.si1TypeDefEnum = .variant(si1TypeDefVariant: try Si1TypeDefVariant(scaleDecoder: scaleDecoder))
        }
        //isSequence
        else if rawValue == 2{
            self.si1TypeDefEnum = .sequence(si1TypeDefSequence: try Si1TypeDefSequence(scaleDecoder: scaleDecoder))
        }
        //array
        else if rawValue == 3{
            self.si1TypeDefEnum = .array(defArrayMetadata: try Si1TypeDefArray(scaleDecoder: scaleDecoder))
        }
        //tuple
        else if rawValue == 4{
            self.si1TypeDefEnum = .tuple(si1TypeDefTuple: try Si1TypeDefTuple(scaleDecoder: scaleDecoder))
        }
        //primitive
        else if rawValue == 5{
            self.si1TypeDefEnum = .primitive(si1TypeDefPrimitive: try Si1TypeDefPrimitive(scaleDecoder: scaleDecoder))
        }
        //compact
        else if rawValue == 6{
            self.si1TypeDefEnum = .compact(si1TypeDefCompact: try Si1TypeDefCompact(scaleDecoder: scaleDecoder))
        }
        //bitsequence
        else if rawValue == 7{
            self.si1TypeDefEnum = .bitSequence(si1TypeDefBitSequence: try Si1TypeDefBitSequence(scaleDecoder: scaleDecoder))
        }
        //historicMetaCompat
        else if rawValue == 8{
            let type = try String(scaleDecoder: scaleDecoder)
            self.si1TypeDefEnum = .historicMetaCompat(type: type)
        }
    }
}
public struct Si1TypeParameter{
    public let name: String
    public let type: ScaleOption<BigUInt>
}
extension Si1TypeParameter: ScaleCodable {
    public func encode(scaleEncoder: ScaleEncoding) throws {
        try name.encode(scaleEncoder: scaleEncoder)
        try type.encode(scaleEncoder: scaleEncoder)
    }
    public init(scaleDecoder: ScaleDecoding) throws {
        self.name = try String(scaleDecoder:scaleDecoder)
        self.type = try ScaleOption<BigUInt>(scaleDecoder: scaleDecoder)
    }
}
public struct TypesMetadata{
    public let id:BigUInt
    public let path: [String]
    public let params:[Si1TypeParameter]
    public let def:Si1TypeDef
    public let docs:[String]
}
extension TypesMetadata: ScaleCodable {
    public func encode(scaleEncoder: ScaleEncoding) throws {
        try path.encode(scaleEncoder: scaleEncoder)
        try id.encode(scaleEncoder: scaleEncoder)
        try params.encode(scaleEncoder: scaleEncoder)
        try def.encode(scaleEncoder: scaleEncoder)
        try docs.encode(scaleEncoder: scaleEncoder)
    }
    public init(scaleDecoder: ScaleDecoding) throws {
        self.id = try BigUInt(scaleDecoder: scaleDecoder)
        self.path = try [String](scaleDecoder: scaleDecoder)
        self.params = try [Si1TypeParameter](scaleDecoder:scaleDecoder)
        self.def = try Si1TypeDef(scaleDecoder:scaleDecoder)
        self.docs = try [String](scaleDecoder:scaleDecoder)
//        print("path =\(self.path)")
//        print("id =\(self.id)")
    }
}
public struct LookupMetadata{
    public let types:[TypesMetadata]
}
extension LookupMetadata: ScaleCodable {
    public func encode(scaleEncoder: ScaleEncoding) throws {
        try types.encode(scaleEncoder: scaleEncoder)
    }
    public init(scaleDecoder: ScaleDecoding) throws {
        self.types = try [TypesMetadata](scaleDecoder: scaleDecoder)
    }
}
