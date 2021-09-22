//
//  AccountId.swift
//  FearlessDemo
//
//  Created by li shuai on 2021/8/5.
//

import Foundation


struct AccountId: ScaleCodable {
    let value: Data

    init(scaleDecoder: ScaleDecoding) throws {
        value = try scaleDecoder.readAndConfirm(count: 32)
    }

    func encode(scaleEncoder: ScaleEncoding) throws {
        scaleEncoder.appendRaw(data: value)
    }
}
