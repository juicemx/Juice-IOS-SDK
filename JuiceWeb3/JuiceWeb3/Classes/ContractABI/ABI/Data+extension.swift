//
//  ByteHelper.swift
//  juiceWallet
//
//  Created by matrixelement on 20/11/2018.
//  Copyright © 2018 ju. All rights reserved.
//


import Foundation

extension Data {
    
    /// Creates an Data instace based on a hex string (example: "ffff" would be <FF FF>).
    ///
    /// - parameter hex: The hex string without any spaces; should only have [0-9A-Fa-f].
    init?(hexStr: String) {
        if hexStr.count % 2 != 0 {
            return nil
        }
        
        let hexArray = Array(hexStr)
        var bytes: [UInt8] = []
        
        for index in stride(from: 0, to: hexArray.count, by: 2) {
            guard let byte = UInt8("\(hexArray[index])\(hexArray[index + 1])", radix: 16) else {
                return nil
            }
            
            bytes.append(byte)
        }
        
        self.init(bytes: bytes, count: bytes.count)
    }
    
    /// Gets one byte from the given index.
    ///
    /// - parameter index: The index of the byte to be retrieved. Note that this should never be >= length.
    ///
    /// - returns: The byte located at position `index`.
    func getByte(at index: Int) -> Int8 {
        let data: Int8 = self.subdata(in: index ..< (index + 1)).withUnsafeBytes { $0.pointee }
        return data
    }
    
    /// Gets an unsigned int (32 bits => 4 bytes) from the given index.
    ///
    /// - parameter index: The index of the uint to be retrieved. Note that this should never be >= length -
    ///                    3.
    ///
    /// - returns: The unsigned int located at position `index`.
    func getUnsignedInteger(at index: Int, bigEndian: Bool = true) -> UInt32 {
        let data: UInt32 =  self.subdata(in: index ..< (index + 4)).withUnsafeBytes { $0.pointee }
        return bigEndian ? data.bigEndian : data.littleEndian
    }
    
    /// Gets an unsigned long integer (64 bits => 8 bytes) from the given index.
    ///
    /// - parameter index: The index of the ulong to be retrieved. Note that this should never be >= length -
    ///                    7.
    ///
    /// - returns: The unsigned long integer located at position `index`.
    func getUnsignedLong(at index: Int, bigEndian: Bool = true) -> UInt64 {
        let data: UInt64 = self.subdata(in: index ..< (index + 8)).withUnsafeBytes { $0.pointee }
        return bigEndian ? data.bigEndian : data.littleEndian
    }
    
    /// Appends the given byte (8 bits) into the receiver Data.
    ///
    /// - parameter data: The byte to be appended.
    mutating func append(byte data: Int8) {
        var data = data
        self.append(UnsafeBufferPointer(start: &data, count: 1))
    }
    
    mutating func append(unsignedInteger data: UInt8, bigEndian: Bool = true) {
        var data = bigEndian ? data.bigEndian : data.littleEndian
        self.append(UnsafeBufferPointer(start: &data, count: 1))
    }
    
    mutating func append(unsignedInteger data: UInt16, bigEndian: Bool = true) {
        var data = bigEndian ? data.bigEndian : data.littleEndian
        self.append(UnsafeBufferPointer(start: &data, count: 1))
    }
    
    /// Appends the given unsigned integer (32 bits; 4 bytes) into the receiver Data.
    ///
    /// - parameter data: The unsigned integer to be appended.
    mutating func append(unsignedInteger data: UInt32, bigEndian: Bool = true) {
        var data = bigEndian ? data.bigEndian : data.littleEndian
        self.append(UnsafeBufferPointer(start: &data, count: 1))
    }
    
    /// Appends the given unsigned long (64 bits; 8 bytes) into the receiver Data.
    ///
    /// - parameter data: The unsigned long to be appended.
    mutating func append(unsignedLong data: UInt64, bigEndian: Bool = true) {
        var data = bigEndian ? data.bigEndian : data.littleEndian
        self.append(UnsafeBufferPointer(start: &data, count: 1))
    }
    
    
    
    static func newData(unsignedLong data: UInt64, bigEndian: Bool = true) -> Data{
        var data = bigEndian ? data.bigEndian : data.littleEndian
        var ret = Data(count: 0)
        ret.append(UnsafeBufferPointer(start: &data, count: 1))
        return ret
    }
    
    static func newData(uint32data: UInt32, bigEndian: Bool = true) -> Data{
        let data = bigEndian ? uint32data.bigEndian : uint32data.littleEndian
        var ret = Data(count: 0)
        ret.append(unsignedInteger: data)
        return ret
    }
    
    static func newData(uInt16Data: UInt16, bigEndian: Bool = true) -> Data {
        let data = bigEndian ? uInt16Data.bigEndian : uInt16Data.littleEndian
        var ret = Data(count: 0)
        ret.append(unsignedInteger: data)
        return ret
    }
    
    static func newData(uInt8Data: UInt8, bigEndian: Bool = true) -> Data {
        let data = bigEndian ? uInt8Data.bigEndian : uInt8Data.littleEndian
        var ret = Data(count: 0)
        ret.append(unsignedInteger: data)
        return ret
    }
    
    func safeGetUnsignedLong(at index: Int, bigEndian: Bool = true) -> UInt64 {
        if self.count < 8 && self.count >= 0{
            let appendN = 8 - self.count
            var appended  = Data()
            for _ in 0...(appendN - 1){
                appended.append(byte: 0)
            }
            appended.append(self)
            
            return appended.getUnsignedLong(at: index, bigEndian:bigEndian)
        }
        return self.getUnsignedLong(at: index, bigEndian: bigEndian)
    }
    
    func toString() -> String{
        return String(data: self, encoding: .utf8) ?? ""
    }
    
}

extension Data {
    
    init<T>(from value: T) {
        self = Swift.withUnsafeBytes(of: value) { Data($0) }
    }
    
    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.pointee }
    }
}

public extension ABI{
    //SolidityType
    public static func rlpdecode(type: SolidityType, data: Data) -> Any {
        return data
    }
    
    public static func stringDecode(data: Data) -> String{
        return String(bytes: data.bytes)
    }
    
    public static func boolDecode(data: Data) -> Bool{
        if data.toHexString() == "0x00" || data.toHexString() == "00"{
            return false
        }else{
            return true
        }
    }
    
    public static func uint64Decode(data: Data) -> UInt64{
        if data.count <= 1{
            return UInt64(0)
        }
        return data.safeGetUnsignedLong(at: 0)
    }
    
    public static func int8Decode(data: Data) -> Int8{
        return data.getByte(at: 0)
    }
    
    public static func int16Decode(data: Data) -> UInt32{
        return data.getUnsignedInteger(at: 0)
    }
    
}

extension Data {
    var toHexOptimized: String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
