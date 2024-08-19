//
//  RuntimeMetadataV14.swift
//  FearlessUtilDemo
//
//  Created by li shuai on 2021/10/18.
//

import Foundation
import BigInt
public struct MetadataType{
    public let type: BigUInt
}
extension MetadataType: ScaleCodable {
    public func encode(scaleEncoder: ScaleEncoding) throws {
        try type.encode(scaleEncoder: scaleEncoder)
    }
    public init(scaleDecoder: ScaleDecoding) throws {
        self.type = try BigUInt(scaleDecoder: scaleDecoder)
    }
}
public struct RuntimeMetadataV14:RuntimeMetadataProtocol{
    public let magicNumber: UInt32
    public let runtimeMetadataVersion: UInt8
    public let lookup: LookupMetadata
    public let pallets: [PalletMetadataV14]
    public let extrinsic:ExtrinsicMetadataV14
    public let type: BigUInt
    
    public func getModuleIndexAndCallIndex(in moduleName: String, callName: String)->(UInt8,UInt8)?{
        guard let moduleIndex = getModuleIndex(moduleName) else {
            return nil
        }
        guard let callIndex = getCallIndex(in: moduleName, callName: callName) else {
            return nil
        }
        return (moduleIndex,callIndex)
    }
    public func getModuleIndex(_ name: String) -> UInt8? {
        pallets.first(where: { $0.name.lowercased() == name.lowercased() })?.index
    }
    public func getModuleNameAndCallName(moduleIndex: UInt8, callIndex: UInt8) -> (String, String)? {
        guard let palletMetadataV14 = pallets.first(where: { $0.index.description == "\(moduleIndex)" }) else {
            return nil
        }
        guard let type = palletMetadataV14.calls?.type else {
            return nil
        }
        guard let typesMetadata = self.lookup.types.first(where: { $0.id == type }) else {
            return nil
        }
        switch typesMetadata.def.si1TypeDefEnum{
        case .variant(let si1TypeDefVariant):
            guard let callName = si1TypeDefVariant.fields.first(where: { $0.index.description == "\(callIndex)" })?.name else {
                return nil
            }
            return (palletMetadataV14.name,callName)
        default:
            return nil
        }
    }
    public func getCallIndex(in moduleName: String, callName: String) -> UInt8? {
       
        guard let palletMetadataV14 = pallets.first(where: { $0.name.lowercased() == moduleName.lowercased() }) else {
            return nil
        }
        guard let type = palletMetadataV14.calls?.type else {
            return nil
        }
        guard let typesMetadata = self.lookup.types.first(where: { $0.id == type }) else {
            return nil
        }
        switch typesMetadata.def.si1TypeDefEnum{
        case .variant(let si1TypeDefVariant):
            guard let callIndex = si1TypeDefVariant.fields.first(where: { $0.name.lowercased() == callName.lowercased() })?.index else {
                return nil
            }
            return callIndex
        default:
            return nil
        }
    }
    public func getTypeField(moduleName: String, callName: String) -> [(String, String)]{
        guard let (moduleIndex, callIndex) = getModuleIndexAndCallIndex(in: moduleName, callName: callName) else {
            return []
        }
        return getTypeField(moduleIndex: moduleIndex, callIndex: callIndex)
    }
        
    public func getTypeField(moduleIndex: UInt8, callIndex: UInt8) -> [(String, String)]{
        guard let palletMetadataV14 = pallets.first(where: { $0.index.description == "\(moduleIndex)" }) else {
            return []
        }
        guard let type = palletMetadataV14.calls?.type else {
            return []
        }
        guard let typesMetadata = self.lookup.types.first(where: { $0.id == type }) else {
            return []
        }
        switch typesMetadata.def.si1TypeDefEnum{
        case .variant(let si1TypeDefVariant):
            var fields = [(String, String)]()
            let field = si1TypeDefVariant.fields.first(where: {$0.index.description == "\(callIndex)"})
            field?.field.forEach { field in
                fields.append((field.name.value ?? "", field.typeName.value ?? ""))
            }
            return fields
        default:
            return []
        }
    }
}

extension RuntimeMetadataV14: ScaleCodable {
    public func encode(scaleEncoder: ScaleEncoding) throws {
        try magicNumber.encode(scaleEncoder: scaleEncoder)
        try runtimeMetadataVersion.encode(scaleEncoder: scaleEncoder)
        try lookup.encode(scaleEncoder: scaleEncoder)
        try pallets.encode(scaleEncoder: scaleEncoder)
        try extrinsic.encode(scaleEncoder: scaleEncoder)
        try type.encode(scaleEncoder: scaleEncoder)
    }
    public init(scaleDecoder: ScaleDecoding) throws {
        self.magicNumber = try UInt32(scaleDecoder: scaleDecoder)
        self.runtimeMetadataVersion = try UInt8(scaleDecoder: scaleDecoder)
        self.lookup = try LookupMetadata(scaleDecoder: scaleDecoder)
        self.pallets = try [PalletMetadataV14](scaleDecoder: scaleDecoder)
        self.extrinsic = try ExtrinsicMetadataV14(scaleDecoder: scaleDecoder)
        self.type = try BigUInt(scaleDecoder: scaleDecoder)
    }
}
public struct RuntimeMetadataHeader{
    public let magicNumber: UInt32
    public let runtimeMetadataVersion: UInt8
}
extension RuntimeMetadataHeader: ScaleCodable {
    public func encode(scaleEncoder: ScaleEncoding) throws {
        try magicNumber.encode(scaleEncoder: scaleEncoder)
        try runtimeMetadataVersion.encode(scaleEncoder: scaleEncoder)
    }
    public init(scaleDecoder: ScaleDecoding) throws {
        self.magicNumber = try UInt32(scaleDecoder: scaleDecoder)
        self.runtimeMetadataVersion = try UInt8(scaleDecoder: scaleDecoder)
    }
}
