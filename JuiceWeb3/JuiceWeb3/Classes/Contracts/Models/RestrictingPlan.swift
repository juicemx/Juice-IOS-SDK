//
//  RestrictingPlan.swift
//  JuiceWeb3Demo
//
//  Created by Admin on 9/7/2019.
//  Copyright © 2019 ju. All rights reserved.
//

import Foundation

public enum DuplicateSignType: UInt32 {
    case prepare = 1
    case viewChange = 2
    case timestampViewChange = 3
}

public struct RestrictingPlan {
    var epoch: UInt64
    var amount: BigUInt
    
    public enum Error: Swift.Error {
        case rlpItemInvalid
    }

    public init(epoch: UInt64, amount: BigUInt) {
        self.epoch = epoch
        self.amount = amount
    }
}

extension RLPItem {
    public init(epoch: UInt64, amount: BigUInt) {
        let epochData = Data.newData(unsignedLong: epoch)
        let epochBytes = epochData.bytes.trimLeadingZeros()
        self = .array(
            .bytes(epochBytes),
            .bigUInt(amount)
        )
    }
}

extension RestrictingPlan: RLPItemConvertible {
    public init(rlp: RLPItem) throws {
        guard let array = rlp.array, array.count == 2 else {
            throw Error.rlpItemInvalid
        }
        
        guard let epoch = array[0].bytes, let amount = array[1].bigUInt else {
            throw Error.rlpItemInvalid
        }

        self.init(epoch: UInt64(bytes: epoch), amount: amount)
    }
    
    public func rlp() throws -> RLPItem {
        return RLPItem(epoch: epoch, amount: amount)
    }
}
