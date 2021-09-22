//
//  StorageKeyFactory+Implicit.swift
//  FearlessDemo
//
//  Created by li shuai on 2021/8/5.
//

import Foundation

public extension StorageKeyFactoryProtocol {
    public func updatedDualRefCount() throws -> Data {
        try createStorageKey(
            moduleName: "System",
            storageName: "UpgradedToDualRefCount"
        )
    }

    public func accountInfoKeyForId(_ identifier: Data) throws -> Data {
        try createStorageKey(
            moduleName: "System",
            storageName: "Account",
            key: identifier,
            hasher: .blake128Concat
        )
    }
    //statemine
    public   func accountAsset(_ assetId: Data,_ identifier: Data) throws -> Data {
        try createStorageKey(
            moduleName: "Assets",
            storageName: "Account",
            key1: assetId,
            hasher1: .blake128Concat,
            key2: identifier,
            hasher2: .blake128Concat)
    }
    //karura
    public  func karuraAccountAsset(_ identifier: Data,_ currentId: Data) throws -> Data {
        try createStorageKey(
            moduleName: "Tokens",
            storageName: "Accounts",
            key1: identifier,
            hasher1: .blake128Concat,
            key2: currentId,
            hasher2: .twox64Concat)
    }
    public  func bondedKeyForId(_ identifier: Data) throws -> Data {
        try createStorageKey(
            moduleName: "Staking",
            storageName: "Bonded",
            key: identifier,
            hasher: .twox64Concat
        )
    }

    public  func stakingInfoForControllerId(_ identifier: Data) throws -> Data {
        try createStorageKey(
            moduleName: "Staking",
            storageName: "Ledger",
            key: identifier,
            hasher: .blake128Concat
        )
    }

    public func activeEra() throws -> Data {
        try createStorageKey(
            moduleName: "Staking",
            storageName: "ActiveEra"
        )
    }

    public func currentEra() throws -> Data {
        try createStorageKey(
            moduleName: "Staking",
            storageName: "CurrentEra"
        )
    }

    public func totalIssuance() throws -> Data {
        try createStorageKey(
            moduleName: "Balances",
            storageName: "TotalIssuance"
        )
    }

    public func historyDepth() throws -> Data {
        try createStorageKey(
            moduleName: "Staking",
            storageName: "HistoryDepth"
        )
    }

    public func key(from codingPath: StorageCodingPath) throws -> Data {
        try createStorageKey(moduleName: codingPath.moduleName, storageName: codingPath.itemName)
    }
 }
