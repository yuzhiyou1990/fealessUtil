import Foundation

public struct RuntimeDispatchInfo: Codable {
    public  enum CodingKeys: String, CodingKey {
        case dispatchClass = "class"
        case fee = "partialFee"
        case weight
    }

    public let dispatchClass: String
    public let fee: String
    public let weight: UInt64
}
