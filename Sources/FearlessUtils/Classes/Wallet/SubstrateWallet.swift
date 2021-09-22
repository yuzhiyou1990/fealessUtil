//
//  SubstrateWallet.swift
//  FearlessDemo
//
//  Created by li shuai on 2021/8/24.
//

import Foundation
import SubstrateKeychain
import SS58Factory
//签名类型
public enum SubstrateSignType: String, Codable {
    case sr25519
    case ed25519
    case ecdsa
}
public enum SubstrateWalletError :Error {
    case pathParseError
    case deriveSeedError
    case createKeypairFromSeedError
}
public final class SubstrateWallet {

    public  static func createKeyPair(mnemonic mnemonicStr: String,cryptoType:SubstrateSignType,derivationPath path :String) throws -> KeyPair {
        var keyPair:KeyPair
        
        switch cryptoType {
        case .ecdsa:
            keyPair = try EcdsaKeyPair(parsing: mnemonicStr+path)
            break
        case .ed25519:
            keyPair = try Ed25519KeyPair(parsing: mnemonicStr+path)
            break
        case .sr25519:
            keyPair = try Sr25519KeyPair(phrase: mnemonicStr+path)
            break
        }
        return keyPair
    }
    public  static func createKeypairWithRaw(_ raw: Data,_ cryptoType:SubstrateSignType,_ path :String?)throws -> KeyPair {
        var keyPair:KeyPair
        let pathComponents =  try pathComponent(junctionsPath: path ?? "")
        switch cryptoType {
        case .ecdsa:
            let superKeyPair = try EcdsaKeyPair(raw: raw)
            if pathComponents.count > 0{
                keyPair = try superKeyPair.derive(path: pathComponents)
            }else{keyPair = superKeyPair}
            break
        case .ed25519:
            let superKeyPair = try Ed25519KeyPair(raw: raw)
            if pathComponents.count > 0{
                keyPair = try superKeyPair.derive(path: pathComponents)
            }else{keyPair = superKeyPair}
            break
        case .sr25519:
            let superKeyPair = try Sr25519KeyPair(raw: raw)
            if pathComponents.count > 0{
                keyPair = try superKeyPair.derive(path: pathComponents)
            }else{keyPair = superKeyPair}
            break
        }
        return keyPair
    }
    public static func createKeypairWithSeed(_ seed: Data,_ cryptoType:SubstrateSignType,_ path :String?)throws -> KeyPair {
        let pathComponents =  try pathComponent(junctionsPath: path ?? "")
        var keyPair:KeyPair
        switch cryptoType {
        case .ecdsa:
            let superKeyPair = try EcdsaKeyPair(seed: seed)
            if pathComponents.count > 0 {
                keyPair = try superKeyPair.derive(path: pathComponents)
            }else{keyPair = superKeyPair}
            break
        case .ed25519:
            let edseed = try EDSeed(raw: seed)
            let superKeyPair = Ed25519KeyPair(keyPair: EDKeyPair(seed: edseed))
            if pathComponents.count > 0 {
                keyPair = try superKeyPair.derive(path: pathComponents)
            }else{keyPair = superKeyPair}
            break
        case .sr25519:
            let superKeyPair = try Sr25519KeyPair(seed: seed)
            if pathComponents.count > 0 {
                keyPair = try superKeyPair.derive(path: pathComponents)
            }else{keyPair = superKeyPair}
            break
        }
        return keyPair
    }
    public static let hardSeparator = "//"
    public static func pathComponent(junctionsPath:String) throws -> [PathComponent]{
        let pathComponents:[PathComponent] = junctionsPath.components(separatedBy: hardSeparator).compactMap { code in
            guard code != "",let pathComponent = try? PathComponent(hard: UInt32(UInt(code)!)) else{
                return nil
            }
            return pathComponent
        }
        return pathComponents
    }
    public static func createDefinition(accountAddr addr: String, keypair: KeyPair, cryptoType:SubstrateSignType,password: String) throws ->String{
        switch cryptoType {
        case .ecdsa:
            let keypair_ecdsa = keypair as! EcdsaKeyPair
            return try createDefinition(accountAddr: addr, secretKey: Data(bytes: keypair_ecdsa.privateData, count: keypair_ecdsa.privateData.count), publicKey: keypair.rawPubKey, cryptoType: .ecdsa, password: password)
            
        case .ed25519:
            let keypair_ed25519 = keypair as! Ed25519KeyPair
            return try createDefinition(accountAddr: addr, secretKey: keypair_ed25519.keyPair.privateRaw, publicKey: keypair_ed25519.keyPair.publicKey.raw, cryptoType: .ed25519, password: password)
        case .sr25519:
            let keypair_sr25519 = keypair as! Sr25519KeyPair
            return try createDefinition(accountAddr: addr, secretKey: keypair_sr25519.keyPair.privateRaw, publicKey: keypair_sr25519.keyPair.publicKey.raw, cryptoType: .sr25519, password: password)
            
        }
    }
    public static func miniSeed(seed:Data,cryptoType:SubstrateSignType) throws -> Data {
        switch cryptoType {
        case .sr25519:
            return try SRSeed(raw: seed.prefix(SRSeed.size)).raw
        case .ed25519:
            return try EDSeed(raw: seed.prefix(EDSeed.size)).raw
        case .ecdsa:
            return seed
        }
    }
    public static func createDefinition(accountAddr addr: String, secretKey secretData:Data, publicKey publicData:Data, cryptoType:CryptoType,password: String) throws ->String{
        let builder = KeystoreBuilder()
        let keystoreData = KeystoreData(
            address: addr,
            secretKeyData: secretData,
            publicKeyData: publicData,
            cryptoType: cryptoType
        )

        let definition = try builder.build(from: keystoreData, password: password)
        let definitionData =  try jsonEncoder.encode(definition)
        return  String(data: definitionData, encoding: String.Encoding.utf8) ?? ""
    }
    public static func restoreKeystoreData(keystore:String ,password:String?)throws ->KeystoreData{
        let keystoreExtractor = KeystoreExtractor()
        let data = keystore.data(using: String.Encoding.utf8)!
        let keystoreData = try keystoreExtractor.extractFromDefinition(jsonDecoder.decode(KeystoreDefinition.self, from: data), password: password)
        return keystoreData
    }
    private static  var jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        if #available(iOS 11.0, *) {
            encoder.outputFormatting = .sortedKeys
        }
        return encoder
    }()
    private static var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    static private func createKeypairFactory(cryptoType: SubstrateSignType)->KeyPair{
        switch cryptoType {
        case .ecdsa:
            return EcdsaKeyPair()
        case .ed25519:
            return Ed25519KeyPair()
        case .sr25519:
            return Sr25519KeyPair()
        }
    }
}
