//
//  Web3.swift
//  Web3
//
//  Created by Koray Koska on 30.12.17.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

public struct Web3 {

    public typealias Web3ResponseCompletion<Result: Codable> = (_ resp: Web3Response<Result>) -> Void
    public typealias BasicWeb3ResponseCompletion = Web3ResponseCompletion<EthereumValue>

    public static let jsonrpc = "2.0"

    // MARK: - Properties

    public let properties: Properties
    

    public struct Properties {
        public let provider: Web3Provider
        public let rpcId: Int
        public let chainId: String
        public let hrp: String
    }

    // MARK: - Convenient properties

    public var provider: Web3Provider {
        return properties.provider
    }

    public var rpcId: Int {
        return properties.rpcId
    }
    
    public var chainId: String {
        return properties.chainId
    }

    /// The struct holding all `net` requests
    public let net: Net

    /// The struct holding all `eth` requests
    public let juice: Juice
    
    /// The struct holding all `staking` contract requests
    public let staking: StakingContract
    
    /// The struct holding all `proposal` contract requests
    public let proposal: ProposalContract
    
    /// The struct holding all `slash` contract requests
    public let slash: SlashContract
    
    /// The struct holding all `restricting` contract requests
    public let restricting: RestrictingPlanContract

    public let reward: RewardContract

    // MARK: - Initialization

    /// Initializes a new instance of `Web3` with the given custom provider.
    /// - Parameters:
    ///   - provider: The provider which handles all requests and responses.
    ///   - rpcId: The rpc id to be used in all requests. Defaults to 1.
    ///   - chainId: chainId
    ///   - hrp: hrp, . Defaults to lax.
    public init(provider: Web3Provider, rpcId: Int = 1, chainId: String, hrp: String = "juc") {
        let properties = Properties(provider: provider, rpcId: rpcId, chainId: chainId, hrp: hrp)
        self.properties = properties
        self.net = Net(properties: properties)
        self.juice = Juice(properties: properties)

        self.staking = StakingContract(juice: self.juice, contractAddress: try! AddrCoder.shared.encode(hrp: hrp, address: JuiceConfig.ContractAddress.stakingContractAddress))
        self.proposal = ProposalContract(juice: self.juice, contractAddress: try! AddrCoder.shared.encode(hrp: hrp, address: JuiceConfig.ContractAddress.proposalContractAddress))
        self.slash = SlashContract(juice: self.juice, contractAddress: try! AddrCoder.shared.encode(hrp: hrp, address: JuiceConfig.ContractAddress.slashContractAddress))
        self.restricting = RestrictingPlanContract(juice: self.juice, contractAddress: try! AddrCoder.shared.encode(hrp: hrp, address: JuiceConfig.ContractAddress.restrictingContractAddress))
        self.reward = RewardContract(juice: self.juice, contractAddress: try! AddrCoder.shared.encode(hrp: hrp, address: JuiceConfig.ContractAddress.rewardContractAddress))
    }

    // MARK: - Web3 methods

    /**
     * Returns the current client version.
     *
     * e.g.: "Mist/v0.9.3/darwin/go1.4.1"
     *
     * - parameter response: The response handler. (Returns `String` - The current client version)
     */
    public func clientVersion(response: @escaping Web3ResponseCompletion<String>) {
        let req = BasicRPCRequest(id: rpcId, jsonrpc: type(of: self).jsonrpc, method: "web3_clientVersion", params: [])

        provider.send(request: req, response: response)
    }

    // MARK: - Net methods

    public struct Net {

        public let properties: Properties

        /**
         * Returns the current network id (chain id).
         *
         * e.g.: "1" - Ethereum Mainnet, "2" - Morden testnet, "3" - Ropsten Testnet
         *
         * - parameter response: The response handler. (Returns `String` - The current network id)
         */
        public func version(response: @escaping Web3ResponseCompletion<String>) {
            let req = BasicRPCRequest(id: properties.rpcId, jsonrpc: Web3.jsonrpc, method: "net_version", params: [])

            properties.provider.send(request: req, response: response)
        }

        /**
         * Returns number of peers currently connected to the client.
         *
         * e.g.: 0x2 - 2
         *
         * - parameter response: The response handler. (Returns `EthereumQuantity` - Integer of the number of connected peers)
         */
        public func peerCount(response: @escaping Web3ResponseCompletion<EthereumQuantity>) {
            let req = BasicRPCRequest(id: properties.rpcId, jsonrpc: Web3.jsonrpc, method: "net_peerCount", params: [])

            properties.provider.send(request: req, response: response)
        }
    }

    // MARK: - Eth methods

    public struct Juice {

        public let properties: Properties
        
        // MARK: - Methods
        public func getSchnorrNIZKProve(ledgerName: String = "sys",response: @escaping Web3ResponseCompletion<String>) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "admin_getSchnorrNIZKProve",
                params: [ledgerName])
            properties.provider.send(request: req, response: response)
        }

        public func getProgramVersion(response: @escaping Web3ResponseCompletion<ProgramVersion>) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "admin_getProgramVersion",
                params: [])
            properties.provider.send(request: req, response: response)
        }

        public func protocolVersion(response: @escaping Web3ResponseCompletion<String>) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "juice_protocolVersion",
                params: []
            )

            properties.provider.send(request: req, response: response)
        }

        public func syncing(ledgerName: String = "sys",response: @escaping Web3ResponseCompletion<EthereumSyncStatusObject>) {
            let req = BasicRPCRequest(id: properties.rpcId, jsonrpc: Web3.jsonrpc, method: "juice_syncing", params: [ledgerName])

            properties.provider.send(request: req, response: response)
        }

        public func gasPrice(ledgerName: String = "sys",response: @escaping Web3ResponseCompletion<EthereumQuantity>) {
            let req = BasicRPCRequest(id: properties.rpcId, jsonrpc: Web3.jsonrpc, method: "juice_gasPrice", params: [ledgerName])

            properties.provider.send(request: req, response: response)
        }

        public func accounts(response: @escaping Web3ResponseCompletion<[String]>) {
            let req = BasicRPCRequest(id: properties.rpcId, jsonrpc: Web3.jsonrpc, method: "juice_accounts", params: [])

            properties.provider.send(request: req, response: response)
        }

        public func blockNumber(
            ledgerName: String = "sys",
            response: @escaping Web3ResponseCompletion<EthereumQuantity>)
        {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "juice_blockNumber",
                params: [ledgerName]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getBalance(
            ledgerName: String = "sys",
            address: String,
            block: EthereumQuantityTag,
            response: @escaping Web3ResponseCompletion<EthereumQuantity>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "juice_getBalance",
                params: [ledgerName,address, block]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getStorageAt(
            ledgerName: String = "sys",
            address: String,
            position: EthereumQuantity,
            block: EthereumQuantityTag,
            response: @escaping Web3ResponseCompletion<EthereumData>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "juice_getStorageAt",
                params: [ledgerName, address, position, block]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getTransactionCount(
            ledgerName: String = "sys",
            address: String,
            block: EthereumQuantityTag,
            response: @escaping Web3ResponseCompletion<EthereumQuantity>
            ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "juice_getTransactionCount",
                params: [ledgerName, address, block]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getBlockTransactionCountByHash(
            ledgerName: String = "sys",
            blockHash: EthereumData,
            response: @escaping Web3ResponseCompletion<EthereumQuantity>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "juice_getBlockTransactionCountByHash",
                params: [ledgerName, blockHash]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getBlockTransactionCountByNumber(
            ledgerName: String = "sys",
            block: EthereumQuantityTag,
            response: @escaping Web3ResponseCompletion<EthereumQuantity>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "juice_getBlockTransactionCountByNumber",
                params: [ledgerName, block]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getCode(
            ledgerName: String = "sys",
            address: String,
            block: EthereumQuantityTag,
            response: @escaping Web3ResponseCompletion<EthereumData>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "juice_getCode",
                params: [ledgerName, address, block]
            )

            properties.provider.send(request: req, response: response)
        }
        
        public func sendTransaction(
            transaction: EthereumTransaction,
            response: @escaping Web3ResponseCompletion<EthereumData>
        ) {
            guard transaction.from != nil else {
                let error = Web3Response<EthereumData>(error: .requestFailed(nil))
                response(error)
                return
            }
            let req = RPCRequest<[EthereumTransaction]>(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "juice_sendTransaction",
                params: [transaction]
            )
            properties.provider.send(request: req, response: response)
        }

        public func sendRawTransaction(
            ledgerName: String = "sys",
            transaction: EthereumSignedTransaction,
            response: @escaping Web3ResponseCompletion<EthereumData>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "juice_sendRawTransaction",
                params: [ledgerName,transaction.rlp()]
            )

            properties.provider.send(request: req, response: response)
        }

        public func call(
            call: EthereumCall,
            block: EthereumQuantityTag,
            response: @escaping Web3ResponseCompletion<EthereumData>
        ) {
            let req = RPCRequest<EthereumCallParams>(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "juice_call",
                params: EthereumCallParams(call: call, block: block)
            )

            properties.provider.send(request: req, response: response)
        }

        public func estimateGas(call: EthereumCall, response: @escaping Web3ResponseCompletion<EthereumQuantity>) {
            let req = RPCRequest<[EthereumCall]>(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "juice_estimateGas",
                params: [call]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getBlockByHash(
            ledgerName: String = "sys",
            blockHash: EthereumData,
            fullTransactionObjects: Bool,
            response: @escaping Web3ResponseCompletion<EthereumBlockObject?>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "juice_getBlockByHash",
                params: [ledgerName, blockHash, fullTransactionObjects]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getBlockByNumber(
            ledgerName: String = "sys",
            block: EthereumQuantityTag,
            fullTransactionObjects: Bool,
            response: @escaping Web3ResponseCompletion<EthereumBlockObject?>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "juice_getBlockByNumber",
                params: [ledgerName, block, fullTransactionObjects]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getTransactionByHash(
            ledgerName: String = "sys",
            blockHash: EthereumData,
            response: @escaping Web3ResponseCompletion<EthereumTransactionObject?>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "juice_getTransactionByHash",
                params: [ledgerName, blockHash]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getTransactionByBlockHashAndIndex(
            ledgerName: String = "sys",
            blockHash: EthereumData,
            transactionIndex: EthereumQuantity,
            response: @escaping Web3ResponseCompletion<EthereumTransactionObject?>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "juice_getTransactionByBlockHashAndIndex",
                params: [ledgerName, blockHash, transactionIndex]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getTransactionByBlockNumberAndIndex(
            ledgerName: String = "sys",
            block: EthereumQuantityTag,
            transactionIndex: EthereumQuantity,
            response: @escaping Web3ResponseCompletion<EthereumTransactionObject?>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "juice_getTransactionByBlockNumberAndIndex",
                params: [ledgerName, block, transactionIndex]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getTransactionReceipt(
            ledgerName: String = "sys",
            transactionHash: EthereumData,
            response: @escaping Web3ResponseCompletion<EthereumTransactionReceiptObject?>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "juice_getTransactionReceipt",
                params: [ledgerName, transactionHash]
            )

            properties.provider.send(request: req, response: response)
        }
    }
}
