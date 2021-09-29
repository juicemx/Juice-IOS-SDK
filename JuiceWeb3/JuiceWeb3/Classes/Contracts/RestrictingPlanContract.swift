//
//  RestrictingPlanContract.swift
//  JuiceWeb3Demo
//
//  Created by Admin on 4/7/2019.
//  Copyright © 2019 ju. All rights reserved.
//

import Foundation

public class RestrictingPlanContract: PlantonContractProtocol {
    
    var juice: Web3.Juice
    var contractAddress: String
    
    required init(juice: Web3.Juice, contractAddress: String) {
        self.juice = juice
        self.contractAddress = contractAddress
    }
    
    public func createRestrictingPlan(
        account: String,
        plans: [RestrictingPlan],
        sender: String,
        privateKey: String,
        gas: BigUInt? = nil,
        gasPrice: BigUInt? = nil,
        completion: JuiceCommonCompletionV2<Data?>?) {

        let funcObject = FuncType.createRestrictingPlan(account: account, plans: plans)
        juiceSendRawTransaction(funcObject, sender: sender, privateKey: privateKey, gas: gas, gasPrice: gasPrice, completion: completion)
    }
    
    public func getRestrictingPlanInfo(
        sender: String,
        account: String,
        completion: JuiceCommonCompletionV2<JuiceContractCallResponse<RestrictingInfo>?>?) {
        let funcObject = FuncType.restrictingInfo(account: account)
        juiceCall(funcObject, sender: sender, completion: completion)
    }
}

extension RestrictingPlanContract {
    public func getGasCreateRestrictingPlan(
        account: String,
        plans: [RestrictingPlan]) -> BigUInt {
        let funcObject = FuncType.createRestrictingPlan(account: account, plans: plans)
        return funcObject.gas
    }
}

