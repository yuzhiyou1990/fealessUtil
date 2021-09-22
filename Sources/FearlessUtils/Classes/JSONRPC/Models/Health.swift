import Foundation

public struct Health: Decodable {
    public  let isSyncing: Bool
    public  let peers: Int
    public  let shouldHavePeers: Bool
}
