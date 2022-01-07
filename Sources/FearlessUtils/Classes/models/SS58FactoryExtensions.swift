import Foundation
import SS58Factory

public enum SS58AddressFactoryError: Error {
     case unexpectedAddress
}

// Deprecated: better not to use this methods anymore, will be removed when we get rid of SNAddressType
extension SS58AddressFactoryProtocol {
    public  func extractAddressType(from address: String) throws -> UInt16 {
        let addressTypeValue = try type(fromAddress: address)
        return addressTypeValue.uint16Value
    }

    public func accountId(from address: String) throws -> Data {
        let addressType = try extractAddressType(from: address)
        return try accountId(fromAddress: address, type: addressType)
    }

    public func accountId(fromAddress: String, type: UInt16) throws -> Data {
        try accountId(fromAddress: fromAddress, type: type)
    }

    public func addressFromAccountId(data: AccountId, type: UInt16) throws -> String {
        try address(fromAccountId: data.value, type: type)
    }
}
