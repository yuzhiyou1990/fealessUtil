import Foundation
import RobinHood

typealias RuntimeVersionUpdate = JSONRPCSubscriptionUpdate<RuntimeVersion>
typealias StorageSubscriptionUpdate = JSONRPCSubscriptionUpdate<StorageUpdate>
typealias JSONRPCQueryOperation = JSONRPCOperation<StorageQuery, [StorageUpdate]>
