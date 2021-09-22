//
//  CallCodingPath.swift
//  FearlessDemo
//
//  Created by li shuai on 2021/8/5.
//

import Foundation
public struct CallCodingPath: Equatable, Codable {
    public let moduleName: String
    public let callName: String
    public init(moduleName: String,callName: String){
        self.moduleName = moduleName
        self.callName = callName
    }
}

public extension CallCodingPath {
    var isTransfer: Bool {
        [.transfer, .transferKeepAlive].contains(self)
    }

    static var transfer: CallCodingPath {
        CallCodingPath(moduleName: "Balances", callName: "transfer")
    }

    static var transferKeepAlive: CallCodingPath {
        CallCodingPath(moduleName: "Balances", callName: "transfer_keep_alive")
    }
}
