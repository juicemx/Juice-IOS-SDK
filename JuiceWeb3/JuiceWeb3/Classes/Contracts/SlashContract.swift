//
//  SlashContract.swift
//  JuiceWeb3Demo
//
//  Created by Admin on 4/7/2019.
//  Copyright © 2019 ju. All rights reserved.
//

import Foundation

public class SlashContract: PlantonContractProtocol {
    
    var juice: Web3.Juice
    var contractAddress: String
    
    required init(juice: Web3.Juice, contractAddress: String) {
        self.juice = juice
        self.contractAddress = contractAddress
    }
    
    public func reportDuplicateSign(
        typ: UInt8, // 代表双签类型 1：prepareBlock，2：prepareVote，3：viewChange
        data: String, // 单个证据的json值
        sender: String,
        privateKey: String,
        gas: BigUInt? = nil,
        gasPrice: BigUInt? = nil,
        completion: JuiceCommonCompletionV2<Data?>?) {

        let funcObject = FuncType.reportMultiSign(typ: typ, data: data)
        juiceSendRawTransaction(funcObject, sender: sender, privateKey: privateKey, gas: gas, gasPrice: gasPrice, completion: completion)
    }
    
    public func checkDuplicateSign(
        sender: String,
        typ: DuplicateSignType,
        addr: String,
        blockNumber: UInt64,
        completion: JuiceCommonCompletionV2<JuiceContractCallResponse<String>?>?) {
        let funcObject = FuncType.checkMultiSign(typ: typ.rawValue, addr: addr, blockNumber: blockNumber)
        juiceCall(funcObject, sender: sender, completion: completion)
    }
}

extension SlashContract {
    public func getGasReportDoubleSign(
        typ: UInt8,
        data: String) -> BigUInt {
        let funcObject = FuncType.reportMultiSign(typ: typ, data: data)
        return funcObject.gas
    }
}
