//
//  StorageCodingPath.swift
//  FearlessDemo
//
//  Created by li shuai on 2021/8/5.
//

import Foundation

public struct StorageCodingPath: Equatable {
    public  let moduleName: String
    public  let itemName: String
}

public extension StorageCodingPath {
    public  static var account: StorageCodingPath {
        StorageCodingPath(moduleName: "System", itemName: "Account")
    }

    public   static var events: StorageCodingPath {
        StorageCodingPath(moduleName: "System", itemName: "Events")
    }

    public  static var activeEra: StorageCodingPath {
        StorageCodingPath(moduleName: "Staking", itemName: "ActiveEra")
    }

    public  static var currentEra: StorageCodingPath {
        StorageCodingPath(moduleName: "Staking", itemName: "CurrentEra")
    }

    public  static var erasStakers: StorageCodingPath {
        StorageCodingPath(moduleName: "Staking", itemName: "ErasStakers")
    }

    public  static var erasPrefs: StorageCodingPath {
        StorageCodingPath(moduleName: "Staking", itemName: "ErasValidatorPrefs")
    }

    public  static var controller: StorageCodingPath {
        StorageCodingPath(moduleName: "Staking", itemName: "Bonded")
    }

    public  static var stakingLedger: StorageCodingPath {
        StorageCodingPath(moduleName: "Staking", itemName: "Ledger")
    }

    public   static var nominators: StorageCodingPath {
        StorageCodingPath(moduleName: "Staking", itemName: "Nominators")
    }

    public  static var validatorPrefs: StorageCodingPath {
        StorageCodingPath(moduleName: "Staking", itemName: "Validators")
    }

    public  static var totalIssuance: StorageCodingPath {
        StorageCodingPath(moduleName: "Balances", itemName: "TotalIssuance")
    }

    public static var identity: StorageCodingPath {
        StorageCodingPath(moduleName: "Identity", itemName: "IdentityOf")
    }

    public  static var superIdentity: StorageCodingPath {
        StorageCodingPath(moduleName: "Identity", itemName: "SuperOf")
    }

    public static var slashingSpans: StorageCodingPath {
        StorageCodingPath(moduleName: "Staking", itemName: "SlashingSpans")
    }

    public static var unappliedSlashes: StorageCodingPath {
        StorageCodingPath(moduleName: "Staking", itemName: "UnappliedSlashes")
    }

    public  static var minNominatorBond: StorageCodingPath {
        StorageCodingPath(moduleName: "Staking", itemName: "MinNominatorBond")
    }

    public  static var counterForNominators: StorageCodingPath {
        StorageCodingPath(moduleName: "Staking", itemName: "CounterForNominators")
    }

    public  static var maxNominatorsCount: StorageCodingPath {
        StorageCodingPath(moduleName: "Staking", itemName: "MaxNominatorsCount")
    }

    public static var payee: StorageCodingPath {
        StorageCodingPath(moduleName: "Staking", itemName: "Payee")
    }

    public static var historyDepth: StorageCodingPath {
        StorageCodingPath(moduleName: "Staking", itemName: "HistoryDepth")
    }

    public static var totalValidatorReward: StorageCodingPath {
        StorageCodingPath(moduleName: "Staking", itemName: "ErasValidatorReward")
    }

    public static var rewardPointsPerValidator: StorageCodingPath {
        StorageCodingPath(moduleName: "Staking", itemName: "ErasRewardPoints")
    }

    public static var validatorExposureClipped: StorageCodingPath {
        StorageCodingPath(moduleName: "Staking", itemName: "ErasStakersClipped")
    }

    public  static var electionPhase: StorageCodingPath {
        StorageCodingPath(moduleName: "ElectionProviderMultiPhase", itemName: "CurrentPhase")
    }

    public static var parachains: StorageCodingPath {
        StorageCodingPath(moduleName: "Paras", itemName: "Parachains")
    }

    public  static var parachainSlotLeases: StorageCodingPath {
        StorageCodingPath(moduleName: "Slots", itemName: "Leases")
    }

    public static var crowdloanFunds: StorageCodingPath {
        StorageCodingPath(moduleName: "Crowdloan", itemName: "Funds")
    }

    public  static var blockNumber: StorageCodingPath {
        StorageCodingPath(moduleName: "System", itemName: "Number")
    }
}
