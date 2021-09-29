//
//  ProposalContract.swift
//  JuiceWeb3Demo
//
//  Created by Admin on 4/7/2019.
//  Copyright © 2019 ju. All rights reserved.
//

import Foundation

public enum VoteOption: UInt8 {
    case Yeas = 1
    case Nays = 2
    case Abstentions = 3
}

public class ProposalContract: PlantonContractProtocol {
    
    var juice: Web3.Juice
    var contractAddress: String
    
    required init(juice: Web3.Juice, contractAddress: String) {
        self.juice = juice
        self.contractAddress = contractAddress
    }
    
    public func submitText(
        verifier: String,
        pIDID: String,
        sender: String,
        privateKey: String,
        gas: BigUInt? = nil,
        gasPrice: BigUInt? = nil,
        completion: JuiceCommonCompletionV2<Data?>?) {

        let funcObject = FuncType.submitText(verifier: verifier, pIDID: pIDID)
        juiceSendRawTransaction(funcObject, sender: sender, privateKey: privateKey, gas: gas, gasPrice: gasPrice, completion: completion)
    }
    
    public func submitVersion(
        verifier: String,
        pIDID: String,
        newVersion: UInt32,
        endVotingBlock: UInt64,
        sender: String,
        privateKey: String,
        gas: BigUInt? = nil,
        gasPrice: BigUInt? = nil,
        completion: JuiceCommonCompletionV2<Data?>?) {
        
        let funcObject = FuncType.submitVersion(verifier: verifier, pIDID: pIDID, newVersion: newVersion, endVotingBlock: endVotingBlock)
        juiceSendRawTransaction(funcObject, sender: sender, privateKey: privateKey, gas: gas, gasPrice: gasPrice, completion: completion)
    }

    public func submitParam(
        verifier: String,
        pIDID: String,
        module: String,
        name: String,
        newValue: String,
        sender: String,
        privateKey: String,
        gas: BigUInt? = nil,
        gasPrice: BigUInt? = nil,
        completion: JuiceCommonCompletionV2<Data?>?) {
        let funcObject = FuncType.submitParam(verifier: verifier, pIDID: pIDID, module: module, name: name, newValue: newValue)
        juiceSendRawTransaction(funcObject, sender: sender, privateKey: privateKey, gas: gas, gasPrice: gasPrice, completion: completion)
    }
    
    public func submitCancel(
        verifier: String,
        pIDID: String,
        newVersion: UInt32,
        endVotingRounds: UInt64,
        tobeCanceledProposalID: String,
        sender: String,
        privateKey: String,
        gas: BigUInt? = nil,
        gasPrice: BigUInt? = nil,
        completion: JuiceCommonCompletionV2<Data?>?) {
        
        let funcObject = FuncType.submitCancel(verifier: verifier, pIDID: pIDID, endVotingRounds: endVotingRounds, tobeCanceledProposalID: tobeCanceledProposalID)
        juiceSendRawTransaction(funcObject, sender: sender, privateKey: privateKey, gas: gas, gasPrice: gasPrice, completion: completion)
    }
    
    public func vote(
        verifier: String,
        proposalID: String,
        option: VoteOption,
        sender: String,
        privateKey: String,
        programVersion: UInt32,
        versionSign: String,
        gas: BigUInt? = nil,
        gasPrice: BigUInt? = nil,
        completion: JuiceCommonCompletionV2<Data?>?) {

        let funcObject = FuncType.voteProposal(
            verifier: verifier,
            proposalID: proposalID,
            option: option,
            programVersion: programVersion,
            versionSign: versionSign
        )

        juiceSendRawTransaction(funcObject, sender: sender, privateKey: privateKey, gas: gas, gasPrice: gasPrice, completion: completion)
    }
    
    public func declareVersion(
        verifier: String,
        sender: String,
        privateKey: String,
        programVersion: UInt32,
        versionSign: String,
        gas: BigUInt? = nil,
        gasPrice: BigUInt? = nil,
        completion: JuiceCommonCompletionV2<Data?>?) {
        
        let funcObject = FuncType.declareVersion(verifier: verifier, programVersion: programVersion, versionSign: versionSign)
        juiceSendRawTransaction(funcObject, sender: sender, privateKey: privateKey, gas: gas, gasPrice: gasPrice, completion: completion)
    }
    
    public func getProposal(
        sender: String,
        proposalID: String,
        completion: JuiceCommonCompletionV2<JuiceContractCallResponse<Proposal>?>?) {
        let funcObject = FuncType.proposal(proposalID: proposalID)
        juiceCall(funcObject, sender: sender, completion: completion)
    }
    
    public func getProposalResult(
        sender: String,
        proposalID: String,
        completion: JuiceCommonCompletionV2<JuiceContractCallResponse<TallyResult>?>?) {
        let funcObject = FuncType.proposalResult(proposalID: proposalID)
        juiceCall(funcObject, sender: sender, completion: completion)
    }
    
    public func getProposalList(
        sender: String,
        completion: JuiceCommonCompletionV2<JuiceContractCallResponse<[Proposal]>?>?) {
        let funcObject = FuncType.proposalList
        juiceCall(funcObject, sender: sender, completion: completion)
    }
    
    public func getActiveVersion(
        sender: String,
        completion: JuiceCommonCompletionV2<JuiceContractCallResponse<String>?>?) {
        let funcObject = FuncType.activeVersion
        juiceCall(funcObject, sender: sender, completion: completion)
    }

    public func getGovernParamValue(
        module: String,
        name: String,
        sender: String,
        completion: JuiceCommonCompletionV2<JuiceContractCallResponse<String>?>?) {
        let funcObject = FuncType.getGovernParamValue(module: module, name: name)
        juiceCall(funcObject, sender: sender, completion: completion)
    }

    public func getAccuVerifiersCount(
        proposalID: String,
        blockHash: String,
        sender: String,
        completion: JuiceCommonCompletionV2<JuiceContractCallResponse<[UInt16]>?>?) {
        let funcObject = FuncType.getAccuVerifiersCount(proposalID: proposalID, blockHash: blockHash)
        juiceCall(funcObject, sender: sender, completion: completion)
    }

    public func listGovernParam(
        module: String,
        sender: String,
        completion: JuiceCommonCompletionV2<JuiceContractCallResponse<[Govern]>?>?) {
        let funcObject = FuncType.listGovernParam(module: module)
        juiceCall(funcObject, sender: sender, completion: completion)
    }
}

extension ProposalContract {
    public func getGasSubmitText(
        verifier: String,
        pIDID: String) -> BigUInt {
        let funcObject = FuncType.submitText(verifier: verifier, pIDID: pIDID)
        return funcObject.gas
    }
    
    public func getGasSubmitVersion(
        verifier: String,
        pIDID: String,
        newVersion: UInt32,
        endVotingBlock: UInt64) -> BigUInt {
        let funcObject = FuncType.submitVersion(verifier: verifier, pIDID: pIDID, newVersion: newVersion, endVotingBlock: endVotingBlock)
        return funcObject.gas
    }

    public func getGasSubmitParam(
        verifier: String,
        pIDID: String,
        module: String,
        name: String,
        newValue: String) -> BigUInt {
        let funcObject = FuncType.submitParam(verifier: verifier, pIDID: pIDID, module: module, name: name, newValue: newValue)
        return funcObject.gas
    }
    
    public func getGasSubmitCancel(
        verifier: String,
        pIDID: String,
        newVersion: UInt32,
        endVotingRounds: UInt64) -> BigUInt {
        let funcObject = FuncType.submitVersion(verifier: verifier, pIDID: pIDID, newVersion: newVersion, endVotingBlock: endVotingRounds)
        return funcObject.gas
    }
    
    public func getGasVote(
        verifier: String,
        proposalID: String,
        option: VoteOption,
        programVersion: UInt32,
        versionSign: String) -> BigUInt {
        
        let funcObject = FuncType.voteProposal(verifier: verifier, proposalID: proposalID, option: option, programVersion: programVersion, versionSign: versionSign)
        return funcObject.gas
    }
    
    public func getGasDeclareVersion(
        verifier: String,
        programVersion: UInt32,
        versionSign: String) -> BigUInt {
        
        let funcObject = FuncType.declareVersion(verifier: verifier, programVersion: programVersion, versionSign: versionSign)
        return funcObject.gas
    }
}
