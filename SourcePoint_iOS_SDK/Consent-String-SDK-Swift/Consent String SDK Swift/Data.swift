//
//  Data.swift
//  gdprConsentStringSwift
//
//  Created by Daniel Kanaan on 4/19/18.
//  Copyright © 2018 Daniel Kanaan. All rights reserved.
//

import Foundation

extension Data {
    
    /**
     This does most of the SDK heavy lifting.  It will return the bits reshuffled into new bytes terminating at toBit.  Bits will be left padded with zeros to fill first byte
     
     For example in a bit string "00000100 10000100" (two bytes), requesting the integer value from bit 0 to bit 7 will return "00000100".  Requesting the bytes from bit 1 to bit 8 would return "00001000". Etc...
     
     Things to note.
     
     1. Results are padded from the left with zeros to fill the first byte.
     2. Requests for a terminating bit after the final bit of actual data will trim the request to last bit.  The last bit will be the least significant bit of the result with zeros padded on the left to 64 bit.  This means that a bit string "0000 0001" or 1 if requested for bit 0 to bit 100 will return 1.
     3. Max length from fromBit to toBit inclusive is 64.  Anything more will be terminated at the 64th bit.
     
     - parameter fromBit: Int64 value of start bit (inclusive)
     - parameter toBit: Int64 value of final bit (inclusive)
 */
    func bytes(fromBit startBit:Int64, toBit endBit:Int64) -> [UInt8] {
        let byteCount = count
        let lastBit = Int64(byteCount * 8 - 1)
        var byteArray = [UInt8]()
        if startBit > lastBit {
            return byteArray
        }
        var realEndBit = endBit
        //limit to length of data
        if endBit > lastBit {
            realEndBit = lastBit
        }
        //limit to 64 bits
        if endBit - startBit > 63 {
            realEndBit = startBit + 63
        }
        if startBit <= endBit, let startByte = byte(forBit: startBit), let endByte = byte(forBit: realEndBit) {
            if startByte == endByte {
                //avoid complexity by removing the case where startBit and endBit are on the same byte
                let leftShift = startBit % 8
                let rightShift =  8 - (realEndBit % 8) - 1
                byteArray.append((self[startByte] << leftShift) >> (rightShift + leftShift))
            } else {
                let rightShift = 8 - (realEndBit % 8) - 1
                let leftShift = 8 - rightShift
                let finalLeftShift = startBit % 8
                var currentByte = endByte
                //addendum is required for when first byte pull is less than next bite push
                let addendum = finalLeftShift > leftShift ? 1 : 0
                while currentByte > startByte + addendum {
                    let beggining = self[currentByte - 1] << leftShift
                    let ending = self[currentByte] >> rightShift
                    byteArray.insert(beggining | ending, at:0)
                    currentByte -= 1
                }
                let finalRightShift =  finalLeftShift + rightShift

                if addendum == 0  {
                    //means that there's some bits on the first byte that need to be added
                     byteArray.insert((self[currentByte] << finalLeftShift) >> finalRightShift , at: 0)
                } else {
                    //means that there's some bits on the second byte and some from the first byte totaling less than a byte
                    let rightBits = (self[currentByte] >> rightShift)
                    let leftBits = (self[currentByte - 1] << finalLeftShift) >> (finalLeftShift - (8 - rightShift))
                    byteArray.insert(leftBits | rightBits , at: 0)
                }
            }
        }
        return byteArray
    }
    
    /**
     This returns bytes of data terminating with the bit at "endBit" and starting at startBit with a maximum byte length of 8.
     
     For example in a bit string "00000100 10000100" (two bytes), requesting the data from bit 0 to bit 7 will return "00000100".  Requesting the bytes from bit 1 to bit 8 would return "00001000". Etc...
     
     Things to note.
     
     1. Results are padded from the left with zeros to fill the first byte.
     2. Requests for a terminating bit after the final bit of actual data will trim the request to last bit.  The last bit will be the least significant bit of the result with zeros padded on the left to 64 bit.  This means that a bit string "0000 0001" or 1 if requested for bit 0 to bit 100 will return 1.
     3. Max length from fromBit to toBit inclusive is 64.  Anything more will be terminated at the 64th bit.
     4. Requesting bits that start after the end of the data will return empty data
     
     - parameter fromBit: Int64 value of start bit (inclusive)
     - parameter toBit: Int64 value of final bit (inclusive)
     */
    func data(fromBit startBit:Int64, toBit endBit:Int64) -> Data {
        let byteArray = bytes(fromBit: startBit, toBit: endBit)
        return Data(bytes: byteArray)
    }
    
    /**
     This returns the bigEndian IntegerValue of the bits terminating with the bit at "endBit" and starting at startBit.
     
     For example in a bit string "00000100 10000100" (two bytes), requesting the data from bit 0 to bit 7 will return 8 or  "00000100".  Requesting the value from bit 1 to bit 8 would return 16 or "00001000". Etc...
     
     Things to note.
     
     1. Results are padded from the left with zeros to fill the first byte.
     2. Requests for a terminating bit after the final bit of actual data will trim the request to last bit.  The last bit will be the least significant bit of the result with zeros padded on the left to 64 bit.  This means that a bit string "0000 0001" or 1 if requested for bit 0 to bit 100 will return 1.
     3. Max length from fromBit to toBit inclusive is 64.  Anything more will be terminated at the 64th bit.
     
     - parameter fromBit: Int64 value of start bit (inclusive)
     - parameter toBit: Int64 value of final bit (inclusive)
     */
    func intValue(fromBit startBit:Int64, toBit endBit:Int64) -> Int64 {
        var dataValue = data(fromBit: startBit, toBit: endBit)
        while dataValue.count < 8 {
            dataValue.insert(0, at: 0)
        }
        let value = UInt64(bigEndian: dataValue.withUnsafeBytes { $0.pointee })
        return Int64(value)
    }
  
}

extension Data {
    
    
    /*
     Returns byte number for bit with error correction for length
     */
    func byte(forBit bit:Int64) -> Int? {
        let lastBit = count * 8 - 1
        if bit > lastBit {
            return nil
        }
        if bit < 0 {
            return nil
        }
        return Int(bit / 8)
    }
}

