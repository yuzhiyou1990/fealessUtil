import Foundation

public enum RuntimeHelperError: Error {
    case invalidCatalogBaseName
    case invalidCatalogNetworkName
    case invalidCatalogMetadataName
}

public final class RuntimeHelper {
    public  static func createRuntimeMetadata(_ name: String) throws -> RuntimeMetadata {
        guard let metadataUrl = Bundle(for: self).url(forResource: name,
                                                      withExtension: "") else {
            throw RuntimeHelperError.invalidCatalogMetadataName
        }

        let hex = try String(contentsOf: metadataUrl)
            .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let expectedData = try Data(hexString: hex)

        let decoder = try ScaleDecoder(data: expectedData)
        return try RuntimeMetadata(scaleDecoder: decoder)
    }
    public  static func createRuntimeMetadataWithData(_ dataHex: String) throws -> RuntimeMetadata {
        let expectedData = try Data(hexString: dataHex)
        let decoder = try ScaleDecoder(data: expectedData)
        return try RuntimeMetadata(scaleDecoder: decoder)
    }
    public static func createRuntimeMetadataV14(_ name: String) throws -> RuntimeMetadataV14 {
        guard let metadataUrl = Bundle(for: self).url(forResource: name,
                                                      withExtension: "") else {
            throw RuntimeHelperError.invalidCatalogMetadataName
        }

        let hex = try String(contentsOf: metadataUrl)
            .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let expectedData = try Data(hexString: hex)

        let decoder = try ScaleDecoder(data: expectedData)
        return try RuntimeMetadataV14(scaleDecoder: decoder)
    }
    public static func createRuntimeMetadataWithData(_ dataHex: String,_ version:UInt8) throws -> RuntimeMetadataProtocol {
        let expectedData = try Data(hexString: dataHex)
        let decoder = try ScaleDecoder(data: expectedData)
        if version >= 14 {
            return try RuntimeMetadataV14(scaleDecoder: decoder)
        }else{
            return try RuntimeMetadata(scaleDecoder: decoder)
        }
    }
    public static func createRuntimeMetadataV14WithData(_ dataHex: String) throws -> RuntimeMetadataV14 {
        let expectedData = try Data(hexString: dataHex)
        let decoder = try ScaleDecoder(data: expectedData)
        return try RuntimeMetadataV14(scaleDecoder: decoder)
    }
    public static func getRuntimeMetadataHeader(_ dataHex: String)throws -> RuntimeMetadataHeader {
        let expectedData = try Data(hexString: dataHex)
        let decoder = try ScaleDecoder(data: expectedData)
        return try RuntimeMetadataHeader(scaleDecoder: decoder)
    }
    public  static func createTypeRegistry(from name: String, runtimeMetadataName: String) throws
    -> TypeRegistry {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
            throw RuntimeHelperError.invalidCatalogBaseName
        }

        let runtimeMetadata = try Self.createRuntimeMetadata(runtimeMetadataName)

        let data = try Data(contentsOf: url)
        let basisNodes = BasisNodes.allNodes(for: runtimeMetadata)
        let registry = try TypeRegistry
            .createFromTypesDefinition(data: data,
                                       additionalNodes: basisNodes)

        return registry
    }

    public  static func createTypeRegistryCatalog(from baseName: String,
                                          networkName: String,
                                          runtimeMetadataName: String)
    throws -> TypeRegistryCatalog {
        let runtimeMetadata = try Self.createRuntimeMetadata(runtimeMetadataName)

        return try createTypeRegistryCatalog(from: baseName,
                                             networkName: networkName,
                                             runtimeMetadata: runtimeMetadata)
    }
    public  static func createTypeRegistryCatalog(from baseName: String,
                                          networkName: String,
                                                  runtimeMetadata: RuntimeMetadataProtocol,_ version:UInt8)throws -> TypeRegistryCatalog? {
        if version >= 14 {
            return nil
        }else{
            return try createTypeRegistryCatalog(from: baseName, networkName: networkName, runtimeMetadata: runtimeMetadata as! RuntimeMetadata)
        }
    }
    public  static func createTypeRegistryCatalog(from baseName: String,
                                          networkName: String,
                                          runtimeMetadata: RuntimeMetadata)
    throws -> TypeRegistryCatalog {
        guard let baseUrl = Bundle.main.url(forResource: baseName, withExtension: "json") else {
            throw RuntimeHelperError.invalidCatalogBaseName
        }

        guard let networkUrl = Bundle.main.url(forResource: networkName,
                                               withExtension: "json") else {
            throw RuntimeHelperError.invalidCatalogNetworkName
        }

        let baseData = try Data(contentsOf: baseUrl)
        let networdData = try Data(contentsOf: networkUrl)

        let registry = try TypeRegistryCatalog
            .createFromBaseTypeDefinition(baseData,
                                          networkDefinitionData: networdData,
                                          runtimeMetadata: runtimeMetadata)

        return registry
    }
    public  static func createTypeRegistryCatalog(from baseName: String,
                                                  versionJson networkJson: String?,
                                                  runtimeMetadata: RuntimeMetadataProtocol,_ version:UInt8)throws -> TypeRegistryCatalog? {
        if version >= 14 {
            return nil
        }else{
            return try createTypeRegistryCatalog(from: baseName, versionJson: networkJson, runtimeMetadata: runtimeMetadata as! RuntimeMetadata)
        }
    }
    public  static func createTypeRegistryCatalog(from baseName: String,
                                          versionJson networkJson: String?,
                                          runtimeMetadata: RuntimeMetadata)
    throws -> TypeRegistryCatalog {
        guard let baseUrl = Bundle.main.url(forResource: baseName, withExtension: "json") else {
            throw RuntimeHelperError.invalidCatalogBaseName
        }

        guard let _networkJson = networkJson,let networdData = _networkJson.data(using: .utf8) else {
            throw RuntimeHelperError.invalidCatalogNetworkName
        }
        let baseData = try Data(contentsOf: baseUrl)
        let registry = try TypeRegistryCatalog
            .createFromBaseTypeDefinition(baseData,
                                          networkDefinitionData: networdData,
                                          runtimeMetadata: runtimeMetadata)

        return registry
    }
}
