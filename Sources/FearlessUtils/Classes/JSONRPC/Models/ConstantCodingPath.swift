import Foundation

public struct ConstantCodingPath {
    let moduleName: String
    let constantName: String
}

public extension ConstantCodingPath {
    static var slashDeferDuration: ConstantCodingPath {
        ConstantCodingPath(moduleName: "Staking", constantName: "SlashDeferDuration")
    }

    static var maxNominatorRewardedPerValidator: ConstantCodingPath {
        ConstantCodingPath(moduleName: "Staking", constantName: "MaxNominatorRewardedPerValidator")
    }

    static var lockUpPeriod: ConstantCodingPath {
        ConstantCodingPath(moduleName: "Staking", constantName: "BondingDuration")
    }

    static var existentialDeposit: ConstantCodingPath {
        ConstantCodingPath(moduleName: "Balances", constantName: "ExistentialDeposit")
    }

    static var paraLeasingPeriod: ConstantCodingPath {
        ConstantCodingPath(moduleName: "Slots", constantName: "LeasePeriod")
    }

    static var babeBlockTime: ConstantCodingPath {
        ConstantCodingPath(moduleName: "Babe", constantName: "ExpectedBlockTime")
    }

    static var minimumContribution: ConstantCodingPath {
        ConstantCodingPath(moduleName: "Crowdloan", constantName: "MinContribution")
    }
}
