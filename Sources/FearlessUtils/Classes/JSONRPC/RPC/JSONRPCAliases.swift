import Foundation
import RobinHood

public typealias RuntimeVersionUpdate = JSONRPCSubscriptionUpdate<RuntimeVersion>
public typealias StorageSubscriptionUpdate = JSONRPCSubscriptionUpdate<StorageUpdate>
public typealias JSONRPCQueryOperation = JSONRPCOperation<StorageQuery, [StorageUpdate]>
