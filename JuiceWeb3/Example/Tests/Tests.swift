import XCTest
import JuiceWeb3

let web3 =  Web3(rpcURL: "http://10.10.8.171:6799", chainId: "200")

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBech32() {
        do {
            let hexAddress = try  AddrCoder.shared.decodeHex(addr: "juc14tu4qg5ptpuljrz3j4x2y5dt4q4v0agrjmp7xy")
            XCTAssertEqual(hexAddress, "0xaaf95022815879f90c51954ca251aba82ac7f503", "the hexAddress should be 0xaaf95022815879f90c51954ca251aba82ac7f503")
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        do {
            let jucAddress = try AddrCoder.shared.encode(hrp: web3.juice.properties.hrp, address: "0xaaf95022815879f90c51954ca251aba82ac7f503")
            XCTAssertEqual(jucAddress, "juc14tu4qg5ptpuljrz3j4x2y5dt4q4v0agrjmp7xy", "the jucAddress should be juc14tu4qg5ptpuljrz3j4x2y5dt4q4v0agrjmp7xy")
        } catch {
            XCTFail(error.localizedDescription)
        }
        
    }
    
    func testGetNonce() {
        let expection = self.expectation(description: "\(#function)")
        
        let from = "0x629a8234e5245723f76622ec9f0e786b0884ba7e"
        let fromAddress = try! AddrCoder.shared.encode(hrp: web3.juice.properties.hrp, address: from)
        
        var nonce : EthereumQuantity?
        web3.juice.getTransactionCount(address: fromAddress, block: EthereumQuantityTag(tagType: .latest)) { resp in
            switch resp.status {
            case .success:
                nonce = resp.result
                XCTAssertNotNil(nonce)
                print(nonce as Any)
            case .failure(let error):
                XCTAssert(false, error.message)
            }
            expection.fulfill()
        }
        
        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }

    }
    
    func testJuiceGetNonce() {
        let expection = self.expectation(description: "\(#function)")
        
        let from = "0x629a8234e5245723f76622ec9f0e786b0884ba7e"
        let fromAddress = try! AddrCoder.shared.encode(hrp: web3.juice.properties.hrp, address: from)
        
        web3.juice.juiceGetNonce(sender: fromAddress, completion: { result, quantity in
            switch result {
            case .success:
                XCTAssertNotNil(quantity)
                print(quantity as Any)
            case .fail(_ ,let msg):
                print(msg ?? "")
            }
            expection.fulfill()
        })
        
        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }
    
    func testCommonTransfer() {
        let expection = self.expectation(description: "\(#function)")
        
//        let gasPrice = JuiceConfig.FuncGasPrice.defaultGasPrice
//        let gasLimit = JuiceConfig.FuncGas.defaultGas
        let gasPrice = BigUInt("10000000000")
        let gasLimit = BigUInt("210000")
        let from = "0x629a8234e5245723f76622ec9f0e786b0884ba7e" // juc1v2dgyd89y3tj8amxytkf7rncdvygfwn7n6tnwf
        let pri = "d9d919e83e450652faf085e31bcee573a89aac37688104667a300724bc569547"
        let to = "0x629a8234e5245723f76622ec9f0e786b0884ba7e"

        var toAddr : EthereumAddress?
        var fromAddr : EthereumAddress?
        var pk : EthereumPrivateKey?
        let txGasPrice = EthereumQuantity(quantity: gasPrice)
        let txGasLimit = EthereumQuantity(quantity: gasLimit)
        let amountOfwei = BigUInt(10).multiplied(by: JuiceConfig.VON.JUC)
        let value = EthereumQuantity(quantity: amountOfwei)
        let data = EthereumData(bytes: [])

        try? toAddr = EthereumAddress(hex: to, eip55: false)
        try? fromAddr = EthereumAddress(hex: from, eip55: false)
        try? pk = EthereumPrivateKey(hexPrivateKey: pri)
        
        let fromAddress = try! AddrCoder.shared.encode(hrp: web3.juice.properties.hrp, address: from)

        let semaphore = DispatchSemaphore(value: 1)
        
        semaphore.wait()
        var nonce : EthereumQuantity?
        web3.juice.getTransactionCount(address: fromAddress, block: EthereumQuantityTag(tagType: .latest)) { resp in
            switch resp.status {
            case .success:
                nonce = resp.result
            case .failure(let error):
                print(error.localizedDescription)
            }
            semaphore.signal()
        }

        semaphore.wait()
        
        let tx = EthereumTransaction(
            nonce: nonce,
            gasPrice: txGasPrice,
            gas: txGasLimit,
            from:fromAddr,
            to: toAddr,
            value: value,
            data : data
        )
        let chainID = EthereumQuantity(quantity: BigUInt(web3.chainId)!)
        let signedTx = try? tx.sign(with: pk!, chainId: chainID) as EthereumSignedTransaction

        web3.juice.sendRawTransaction(transaction: signedTx!, response: { (resp) in
            switch resp.status {
            case .success:
                let txhash = resp.result?.hex()
                print(txhash ?? "")
                XCTAssert(txhash?.count ?? 0 > 0, "hash should be exist")
            case .failure(let error):
                XCTAssert(false, error.message)
            }
            semaphore.signal()
            expection.fulfill()
        })

        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }
    
    func testGetBalance() {
        let expection = self.expectation(description: "\(#function)")
        
        let from = "0x629a8234e5245723f76622ec9f0e786b0884ba7e"
        let fromAddress = try? AddrCoder.shared.encode(hrp: web3.juice.properties.hrp, address: from)
        web3.juice.getBalance(address: fromAddress!, block: .latest) { resp in
            switch resp.status {
            case .success:
                let quantity = resp.result?.quantity
                XCTAssertNotNil(quantity)
                print(quantity as Any)
            case .failure(let error):
                XCTAssert(false, error.message)
            }
            expection.fulfill()
        }
        
        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }
    
    func testGasPrice() {
        let expection = self.expectation(description: "\(#function)")
        
        web3.juice.gasPrice { resp in
            switch resp.status {
            case .success:
                let quantity = resp.result?.quantity
                XCTAssertNotNil(quantity)
            case .failure(let error):
                XCTAssert(false, error.message)
            }
            expection.fulfill()
        }
        
        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }
    
    func testJuiceGetTransactionReceipt() {
        let expection = self.expectation(description: "\(#function)")
        let txHash = "0x97dfe78c990807790688351ac693455814821ed8be7233ec81ec097afabfe484"
        
        web3.juice.juiceGetTransactionReceipt(txHash: txHash, loopTime: 1) { result, obj in
            switch result {
            case .success:
                guard let receipt = obj as? EthereumTransactionReceiptObject,
                      let status = receipt.status?.quantity else {
                    XCTFail("receipt and receipt.status should not be nil")
                    expection.fulfill()
                    return
                }
                print("status: ",status)
            case .fail(_, let msg):
                XCTAssert(false, msg ?? "")
            }
            expection.fulfill()
        }
        
        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }
    
    func testGetTransactionReceipt() {
        let expection = self.expectation(description: "\(#function)")
        let txHash = "0xf62a1b399226c0ed878a628a1e9cd71e3540e7f18719d7e6e66b904553f88426"
        
        web3.juice.getTransactionReceipt(transactionHash: EthereumData(bytes: Data(hex: txHash).bytes)) { resp in
            switch resp.status {
            case .success:
                let receipt = resp.result!
                XCTAssertNotNil(receipt)
                XCTAssertNotNil(receipt!.status)
                print("status: ",receipt!.status as Any)
            case .failure(let error):
                XCTAssert(false, error.message)
            }
            expection.fulfill()
        }
        
        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }
    
    func testERC20Transfer() {
        let expection = self.expectation(description: "\(#function)")
        
        let gasPrice = BigUInt("10000000000")
        let gasLimit = BigUInt("210000")
        let from = "0xaaf95022815879f90c51954ca251aba82ac7f503"
        let pri = "0xf01b06d473a7126d5c6018108accdfc32efaab949e4ca3b4744ea94efd21623f"
        let tokenAddress = "juc10494yr5kxz3lj7g55m7vcd90lleyr9pt22hlzv" // tokenAddress
        let to = try! AddrCoder.shared.decodeHex(addr: tokenAddress)
        let txGasPrice = EthereumQuantity(quantity: gasPrice)
        let txGasLimit = EthereumQuantity(quantity: gasLimit)
        let value = EthereumQuantity(quantity: 0)
        
        let amountBitFormated = BigUInt(13).multiplied(by: 10000000000000000)//BigUInt.mutiply(a: "13", by: ten(power: 16))
        let encodeContent = try! ERC20SignatureHandler.encode(address: from, value: amountBitFormated)
        let bytes = Data(hex: encodeContent).bytes
        let data = EthereumData(bytes: bytes)

        let toAddr = try? EthereumAddress(hex: to, eip55: false)
        let fromAddr = try? EthereumAddress(hex: from, eip55: false)
        let pk = try? EthereumPrivateKey(hexPrivateKey: pri)
        
        let fromAddress = try! AddrCoder.shared.encode(hrp: web3.juice.properties.hrp, address: from)

        let semaphore = DispatchSemaphore(value: 1)
        
        semaphore.wait()
        var nonce : EthereumQuantity?
        web3.juice.getTransactionCount(address: fromAddress, block: EthereumQuantityTag(tagType: .latest)) { resp in
            switch resp.status {
            case .success:
                nonce = resp.result
            case .failure(let error):
                print(error.localizedDescription)
            }
            semaphore.signal()
        }

        semaphore.wait()
        
        let tx = EthereumTransaction(
            nonce: nonce,
            gasPrice: txGasPrice,
            gas: txGasLimit,
            from:fromAddr,
            to: toAddr,
            value: value,
            data : data
        )
        let chainID = EthereumQuantity(quantity: BigUInt(web3.chainId)!)
        let signedTx = try? tx.sign(with: pk!, chainId: chainID) as EthereumSignedTransaction

        web3.juice.sendRawTransaction(transaction: signedTx!, response: { (resp) in
            switch resp.status {
            case .success:
                let txhash = resp.result?.hex()
                print(txhash ?? "")
                XCTAssert(txhash?.count ?? 0 > 0, "hash should be exist")
            case .failure(let error):
                XCTAssert(false, error.message)
            }
            semaphore.signal()
            expection.fulfill()
        })

        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }
    
    func testContractCall() {
        let expection = self.expectation(description: "\(#function)")
        
        let abiPath = Bundle.main.path(forResource: "HelloWorld.abi", ofType: nil)
        let abiData = try? Data(contentsOf: URL(fileURLWithPath: abiPath!))
        guard let data = abiData else { return }
        
        let tokenAddress = "juc10494yr5kxz3lj7g55m7vcd90lleyr9pt22hlzv"
        
        let contract = try? web3.juice.Contract(json: data, abiKey: nil, address: tokenAddress)
        
        contract!["getName"]!().call(completion: { result, error in
            XCTAssert(error == nil, "got an error: \(error?.localizedDescription ?? "")")
            XCTAssert(result != nil, "result should not be nil")
            expection.fulfill()
        })
        
        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }
    
    func testSendTransaction() {
        let expection = self.expectation(description: "\(#function)")
        
        let gasPrice = JuiceConfig.FuncGasPrice.defaultGasPrice
        let gasLimit = JuiceConfig.FuncGas.defaultGas
        let from = "0x629a8234e5245723f76622ec9f0e786b0884ba7e"
        let to = "0x629a8234e5245723f76622ec9f0e786b0884ba7e"

        var toAddr : EthereumAddress?
        var fromAddr : EthereumAddress?
        let txGasPrice = EthereumQuantity(quantity: gasPrice)
        let txGasLimit = EthereumQuantity(quantity: gasLimit)
        let amountOfwei = BigUInt(10).multiplied(by: JuiceConfig.VON.JUC)
        let value = EthereumQuantity(quantity: amountOfwei)
        let data = EthereumData(bytes: [])

        try? toAddr = EthereumAddress(hex: to, eip55: false)
        try? fromAddr = EthereumAddress(hex: from, eip55: false)
        
        let fromAddress = try! AddrCoder.shared.encode(hrp: web3.juice.properties.hrp, address: from)

        let semaphore = DispatchSemaphore(value: 1)
        
        semaphore.wait()
        var nonce : EthereumQuantity?
        web3.juice.getTransactionCount(address: fromAddress, block: EthereumQuantityTag(tagType: .latest)) { resp in
            switch resp.status {
            case .success:
                nonce = resp.result
            case .failure(let error):
                XCTAssert(false, error.message)
            }
            semaphore.signal()
        }

        semaphore.wait()
        
        let tx = EthereumTransaction(
            nonce: nonce,
            gasPrice: txGasPrice,
            gas: txGasLimit,
            from:fromAddr,
            to: toAddr,
            value: value,
            data : data
        )
        
        web3.juice.sendTransaction(transaction: tx) { resp in
            switch resp.status {
            case .success:
                let txhash = resp.result?.hex()
                print(txhash ?? "")
                XCTAssert(txhash?.count ?? 0 > 0, "hash should be exist")
            case .failure(let error):
                XCTAssert(false, error.message)
            }
            semaphore.signal()
            expection.fulfill()
        }

        waitForExpectations(timeout: 30) { (error) in
            print(error?.localizedDescription ?? "")
        }
    }
    
}

// ============================================================================================================

class ERC20SignatureHandler {
    
    private init() {}
    
    static func encode(address: String, value: BigUInt, eip55: Bool = false) throws -> String {
        
        let erc20ContractInstance = ERC20ContractInstance(addressStr: address, eip55: eip55)
        let invocation = erc20ContractInstance.transfer(to: address, value:value)
        let res = try ABI.encodeFunctionCall(invocation)
        return res
    }
}

class ERC20ContractInstance: ERC20Contract {
    
    var juice: Web3.Juice
    var events: [SolidityEvent]
    var address: String?
    
    init(juice: Web3.Juice = web3.juice,
         events: [SolidityEvent] = [GenericERC20Contract.Transfer],
         addressStr: String,
         eip55: Bool) {
        
        self.juice = juice
        self.events = events
        self.address = addressStr
    }

}
