//
//  PlantonContractProtocol.swift
//  JuiceWeb3Demo
//
//  Created by Admin on 4/7/2019.
//  Copyright © 2019 ju. All rights reserved.
//

import Foundation
import Localize_Swift

protocol PlantonContractProtocol {
    var contractAddress: String { get }
    var juice: Web3.Juice { get }
    
    init(juice: Web3.Juice, contractAddress: String)
    
    func juiceCall<T: Decodable>(_ funcType: FuncType, sender: String, completion: JuiceCommonCompletionV2<JuiceContractCallResponse<T>?>?)
    
    func juiceSendRawTransaction(_ funcType: FuncType, sender: String, privateKey: String, value: EthereumQuantity?, gas: BigUInt?, gasPrice: BigUInt?, completion: JuiceCommonCompletionV2<Data?>?)
    
    func juiceContractEstimateGas(_ funcType: FuncType, gasPrice: BigUInt?, completion: JuiceCommonCompletionV2<BigUInt?>?)
}

extension PlantonContractProtocol {
    func juiceCall<T: Decodable>(_ funcType: FuncType, sender: String, completion: JuiceCommonCompletionV2<JuiceContractCallResponse<T>?>?) {
        juice.juiceCall(contractAddress: contractAddress, from: sender, inputs: funcType.rlpData, completion: completion)
    }
    
    func juiceSendRawTransaction(_ funcType: FuncType, sender: String, privateKey: String, value: EthereumQuantity? = nil, gas: BigUInt? = nil, gasPrice: BigUInt? = nil, completion: JuiceCommonCompletionV2<Data?>?) {
        juice.juiceSendRawTransaction(contractAddress: contractAddress, data: funcType.rlpData.bytes, sender: sender, privateKey: privateKey, gasPrice: gasPrice ?? funcType.gasPrice, gas: gas ?? funcType.gas, value: value, estimated: true, completion: completion)
    }
    
    func juiceContractEstimateGas(_ funcType: FuncType, gasPrice: BigUInt? = nil, completion: JuiceCommonCompletionV2<BigUInt?>?) {
        var completion = completion
        
        switch funcType {
        case .submitText,
             .submitVersion,
             .submitCancel:
            DispatchQueue.main.async {
                completion?(.success, funcType.gas.multiplied(by: funcType.gasPrice ?? JuiceConfig.FuncGasPrice.defaultGasPrice))
                completion = nil
            }
        default:
            if let price = gasPrice {
                DispatchQueue.main.async {
                    completion?(.success, funcType.gas.multiplied(by: price))
                    completion = nil
                }
            } else {
                juice.gasPrice { (response) in
                    switch response.status {
                    case .success(let result):
                        JuiceConfig.FuncGasPrice.defaultGasPrice = result.quantity
                    case .failure(_):
                        break
                    }
                    DispatchQueue.main.async {
                        completion?(.success, funcType.gas.multiplied(by: funcType.gasPrice ?? JuiceConfig.FuncGasPrice.defaultGasPrice))
                        completion = nil
                    }
                }
            }
        }
    }
}
