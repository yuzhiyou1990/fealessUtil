import Foundation
import SS58Factory

public enum SS58AddressFactoryError: Error {
    public case unexpectedAddress
}

// Deprecated: better not to use this methods anymore, will be removed when we get rid of SNAddressType
public extension SS58AddressFactoryProtocol {
    public  func extractAddressType(from address: String) throws -> UInt8 {
        let addressTypeValue = try type(fromAddress: address)
        return addressTypeValue.uint8Value
    }

    public func accountId(from address: String) throws -> Data {
        let addressType = try extractAddressType(from: address)
        return try accountId(fromAddress: address, type: addressType)
    }

    public func accountId(fromAddress: String, type: UInt8) throws -> Data {
        try accountId(fromAddress: fromAddress, type: UInt16(type))
    }

    public func addressFromAccountId(data: AccountId, type: UInt8) throws -> String {
        try address(fromAccountId: data.value, type: UInt16(type))
    }
}
