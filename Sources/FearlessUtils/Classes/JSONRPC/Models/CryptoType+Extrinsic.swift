//
//  CryptoType+Extrinsic.swift
//  FearlessDemo
//
//  Created by li shuai on 2021/8/5.
//

import Foundation

public extension CryptoType {
    public init?(version: UInt8) {
        switch version {
        case 0:
            self = .ed25519
        case 1:
            self = .sr25519
        case 2:
            self = .ecdsa
        default:
            return nil
        }
    }

    public var version: UInt8 {
        switch self {
        case .sr25519:
            return 1
        case .ed25519:
            return 0
        case .ecdsa:
            return 2
        }
    }

    public  var signatureLength: Int {
        switch self {
        case .sr25519:
            return 64
        case .ed25519:
            return 64
        case .ecdsa:
            return 65
        }
    }
}
