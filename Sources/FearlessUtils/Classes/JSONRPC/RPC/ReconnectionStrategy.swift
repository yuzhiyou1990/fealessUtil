import Foundation

public protocol ReconnectionStrategyProtocol {
    func reconnectAfter(attempt: Int) -> TimeInterval?
}

public struct ExponentialReconnection: ReconnectionStrategyProtocol {
    let multiplier: Double

    init(multiplier: Double = 0.3) {
        self.multiplier = multiplier
    }

    func reconnectAfter(attempt: Int) -> TimeInterval? {
        multiplier * exp(Double(attempt))
    }
}
