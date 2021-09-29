//
//  RewardContract.swift
//  JuiceWeb3
//
//  Created by Admin on 7/1/2020.
//  Copyright © 2020 ju. All rights reserved.
//

import Foundation

public class RewardContract: PlantonContractProtocol {
    var contractAddress: String
    var juice: Web3.Juice

    required init(juice: Web3.Juice, contractAddress: String) {
        self.juice = juice
        self.contractAddress = contractAddress
    }

    public func withdrawDelegateReward(sender: String, privateKey: String, gasLimit: BigUInt? = nil, gasPrice: BigUInt? = nil, completon: JuiceCommonCompletionV2<Data?>?) {
        let funcObject = FuncType.withdrawDelegateReward
        juiceSendRawTransaction(funcObject, sender: sender, privateKey: privateKey, gas: gasLimit ?? funcObject.gas, gasPrice: gasPrice ?? funcObject.gasPrice, completion: completon)
    }

    public func getDelegateReward(address: String, nodeIDs: [String], sender: String, completion: JuiceCommonCompletionV2<JuiceContractCallResponse<[RewardRecord]>?>?) {
        let funcObject = FuncType.getDelegateReward(address: address, nodeIDs: nodeIDs)
        juiceCall(funcObject, sender: sender, completion: completion)
    }
}
