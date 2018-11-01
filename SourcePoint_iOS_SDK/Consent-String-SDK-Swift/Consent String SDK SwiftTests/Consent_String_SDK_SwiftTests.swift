//
//  Consent_String_SDK_SwiftTests.swift
//  Consent String SDK SwiftTests
//
//  Created by Daniel Kanaan on 4/27/18.
//  Copyright © 2018 Interactive Advertising Bureau. All rights reserved.
//

import XCTest
@testable import Consent_String_SDK_Swift

class Consent_String_SDK_SwiftTests: XCTestCase {
    
    let base64 = ["BOMexSfOMexSfAAABAENAA////ABSABgACAAIA",
                  "BOMexSfOMexSfAAABAENAA////ABSABgACBAAA",
                  "BOMexSfOMexSfAAABAENABAAEAABSABgACBAAA",
                  "BOMexSfOMexSfAAABAENABAAEAABRVVVAA",
                  "BOMexSfOMexSfAAABAENABAAEAABQAIAAA",
                  "BOMexSfOMexSfAAABAENABAAEAABQAIAgA",
                  "BOM03lPOM03lPAAABAENAAAAAAABR//g"
    ]
    let binaries = [
        "000001001110001100011110110001010010011111001110001100011110110001010010011111000000000000000000000001000000000100001101000000000000111111111111111111111111000000000001010010000000000001100000000000000010000000000000001",
        "000001001110001100011110110001010010011111001110001100011110110001010010011111000000000000000000000001000000000100001101000000000000111111111111111111111111000000000001010010000000000001100000000000000010000001000000000",
        "000001001110001100011110110001010010011111001110001100011110110001010010011111000000000000000000000001000000000100001101000000000001000000000000000100000000000000000001010010000000000001100000000000000010000001000000000",
        "0000010011100011000111101100010100100111110011100011000111101100010100100111110000000000000000000000010000000001000011010000000000010000000000000001000000000000000000010100010101010101010101010",
        "0000010011100011000111101100010100100111110011100011000111101100010100100111110000000000000000000000010000000001000011010000000000010000000000000001000000000000000000010100000000000010000000000",
        "0000010011100011000111101100010100100111110011100011000111101100010100100111110000000000000000000000010000000001000011010000000000010000000000000001000000000000000000010100000000000010000000001",
        "0000010011100011001101001101111001010011110011100011001101001101111001010011110000000000000000000000010000000001000011010000000000000000000000000000000000000000000000010100011111111111111"
    ]
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
    func testPerformance() {
        self.measure {
            // Put the code you want to measure the time of here.
            let data = Data(base64Encoded: "BOMYO7eOMYO7eAABAENAAAAAAAAoAAA".base64Padded)!
            XCTAssert(data.intValue(fromBit: 6, toBit: 41) == 15240064734)
        }
    }
    
    func testPadding() {
        var string = "BOMXuBxOMXuBxAABAENAAAAAAAAoAAA"
        XCTAssert(string.base64Padded == "BOMXuBxOMXuBxAABAENAAAAAAAAoAAA=", string.base64Padded)
        string = "BOMXuBxOMXuBxAABAENAAAAAAAAoAAB"
        XCTAssert(string.base64Padded == "BOMXuBxOMXuBxAABAENAAAAAAAAoAAB=", string.base64Padded)
        string = "BOMXuBxOMXuBxAABAENAAAAAAAAoA"
        XCTAssert(string.base64Padded == "BOMXuBxOMXuBxAABAENAAAAAAAAoA===", string.base64Padded)
        string = "BOMXuBxOMXuBxAABAENAAAAAAAAo"
        XCTAssert(string.base64Padded == "BOMXuBxOMXuBxAABAENAAAAAAAAo", string.base64Padded)
        string = "BOMXuBxOMXuBxAABAENAAAAAAAAoAABoo"
        XCTAssert(string.base64Padded == "BOMXuBxOMXuBxAABAENAAAAAAAAoAABoo===", string.base64Padded)
    }
    
    func testBase64Decoding() {
        
        for (index,string) in base64.enumerated() {
            let data = Data(base64Encoded: string.base64Padded)
            XCTAssert(binary(string: binaryStringRepresenting(data: data!), isEqualToBinaryString: binaries[index]))
        }
    }
    
    func testBase64Encoding() {
        let notEqual:[(String,String)] =
            [("BOMXuBxOMXuBxAABAENAAAAAAAAoAAAA",
              "BOMXuBxOMXuBxAABAENAAAAAAAAoAABA"),
             ("BOMXuBxOMXuBxAABAENAAAAAAAAoA",
              "BOMXuBxOMXuBxAABAENAAAAAAAAoAA"),
             ("BOMXuBxOMXuBxAABAENAAAAAAAAo",
              "BOMXuBxOMXuBxAABAENAAAAAAAAoA"),
             ("AA==",
              "A="),
             ("AB=",
              "ABA"),
             ("AABAA",
              "AABA"),
             ("===",
              "A")
        ]
        
        for pair in notEqual {
            let data1 = Data(base64Encoded: pair.0.base64Padded)
            let data2 = Data(base64Encoded: pair.1.base64Padded)
            XCTAssert(data1 != data2,"\(pair.0) == \(pair.1)")
        }
        
        let equal:[(String,String)] = [
            ("BOMXuBxOMXuBxAABAENAAAAAAAAoA=",
             "BOMXuBxOMXuBxAABAENAAAAAAAAoA"),
            ("BOMXuBxOMXuBxAABAENAAAAAAAAoA==",
             "BOMXuBxOMXuBxAABAENAAAAAAAAoA"),
            ("BOMXuBxOMXuBxAABAENAAAAAAAAoA===",
             "BOMXuBxOMXuBxAABAENAAAAAAAAoA")
        ]
        for pair in equal {
            let data1 = Data(base64Encoded: pair.0.base64Padded)
            let data2 = Data(base64Encoded: pair.1.base64Padded)
            XCTAssert(data1 == data2, "\(pair.0) != \(pair.1)")
        }
    }
    
    func testInit() {
        
        for (index,string) in base64.enumerated() {
            
            let consentString = try?ConsentString(consentString: string)
            let representation = binaryStringRepresenting(data: consentString!.consentData)
            XCTAssert(binary(string: representation, isEqualToBinaryString: binaries[index]), "Actual value : \(representation)")
            
        }
        
    }
    
    func testDataExtensions () {
        var data = Data(base64Encoded: "BOMYO7eOMYO7eAABAENAAAAAAAAoAAA".base64Padded)!
        var byteLength = 23
        var lastBit = Int64(byteLength * 8 - 1)
        XCTAssert(data.byte(forBit: 0) == 0)
        XCTAssert(data.byte(forBit: 1) == 0)
        XCTAssert(data.byte(forBit: 6) == 0)
        XCTAssert(data.byte(forBit: 8) == 1)
        XCTAssert(data.byte(forBit: 10) == 1)
        XCTAssert(data.byte(forBit: 15) == 1)
        XCTAssert(data.byte(forBit: 16) == 2)
        XCTAssert(data.byte(forBit: lastBit) == byteLength - 1)
        XCTAssert(data.byte(forBit: lastBit + 1) == nil)
        XCTAssert(data.byte(forBit: lastBit - 8) == byteLength - 2)
        
        XCTAssert(data.intValue(fromBit: 0, toBit: 5) == 1)
        XCTAssert(data.intValue(fromBit: 0, toBit: 7) == 4)
        XCTAssert(data.intValue(fromBit: 6, toBit: 41) == 15240064734)
        XCTAssert(data.intValue(fromBit: 42, toBit: 77) == 15240064734)
        XCTAssert(data.intValue(fromBit: 78, toBit: 89) == 0)
        XCTAssert(data.intValue(fromBit: 90, toBit: 95) == 1)
        XCTAssert(data.intValue(fromBit: 96, toBit: 101) == 0)
        XCTAssert(data.intValue(fromBit: 102, toBit: 113) == 269)
        XCTAssert(data.intValue(fromBit: 114, toBit: 125) == 0)
        XCTAssert(data.intValue(fromBit: 13*8+1, toBit: 13*8+1) == 1)
        
        data = Data(base64Encoded: "AAAB")!
        byteLength = 3
        lastBit = Int64(byteLength * 8 - 1)
        for i in 0..<(byteLength*3-1) {
            XCTAssert(data.intValue(fromBit: Int64(i), toBit: Int64(i)) == 0)
        }
        XCTAssert(data.intValue(fromBit: Int64(byteLength*8-1), toBit: Int64(byteLength*8-1)) == 1)
        XCTAssert(data.intValue(fromBit: 0, toBit: 23) == 1)
        XCTAssert(data.intValue(fromBit: 100000, toBit: 1000000) == 0)
        
        data = Data(base64Encoded: "AAEA")!
        byteLength = 3
        lastBit = Int64(byteLength * 8 - 1)
        XCTAssert(data.intValue(fromBit: 15, toBit: 15) == 1)
        XCTAssert(data.intValue(fromBit: 0, toBit: 15) == 1)
        XCTAssert(data.intValue(fromBit: 16, toBit: 23) == 0)
        
        data = Data(base64Encoded: "AQAA")!
        byteLength = 3
        lastBit = Int64(byteLength * 8 - 1)
        XCTAssert(data.intValue(fromBit: 15, toBit: 15) == 0)
        XCTAssert(data.intValue(fromBit: 16, toBit: 23) == 0)
        XCTAssert(data.intValue(fromBit: 0, toBit: 7) == 1)
        XCTAssert(data.intValue(fromBit: 0, toBit: 8) == 2)
        XCTAssert(data.intValue(fromBit: 0, toBit: 9) == 4)
        XCTAssert(data.intValue(fromBit: 0, toBit: 10) == 8)
        XCTAssert(data.intValue(fromBit: 0, toBit: 11) == 16)
        XCTAssert(data.intValue(fromBit: 0, toBit: 12) == 32)
        
        //Bad Data
        data = Data(base64Encoded: "AAAAAAAB")!
        byteLength = 6
        lastBit = Int64(byteLength * 8 - 1)
        
        XCTAssert(data.intValue(fromBit: 0, toBit: lastBit) == 1)
        XCTAssert(data.intValue(fromBit: 0, toBit: 63) == 1)
        
        
        data = Data(base64Encoded: "AAAAAAABAAAA")!
        byteLength = data.count
        lastBit = Int64(byteLength * 8 - 1)
        
        XCTAssert(data.intValue(fromBit: 0, toBit: lastBit) == 65536, "\(data.intValue(fromBit: 0, toBit: lastBit))")
        XCTAssert(data.intValue(fromBit: 0, toBit: 63) == 65536)
        XCTAssert(data.intValue(fromBit: 0, toBit: 100) == 65536)
        
        
        data = Data(base64Encoded: "BOMexSfOMexSfAAABAENAAAAAAAAoAA".base64Padded)!
        byteLength = data.count
        lastBit = Int64(byteLength * 8 - 1)
        XCTAssert(data.intValue(fromBit: 0, toBit: 5) == 1)
        XCTAssert(data.intValue(fromBit: 6, toBit: 41) == 15241778335)
        XCTAssert(data.intValue(fromBit: 42, toBit: 77) == 15241778335)
        XCTAssert(data.intValue(fromBit: 78, toBit: 89) == 0)
        XCTAssert(data.intValue(fromBit: 90, toBit: 101) == 1)
        XCTAssert(data.intValue(fromBit: 102, toBit: 107) == 0)
        XCTAssert(data.intValue(fromBit: 108, toBit: 119) == 269)
        XCTAssert(data.intValue(fromBit: 120, toBit: 131) == 0)
        XCTAssert(data.intValue(fromBit: 132, toBit: 155) == 0)
        XCTAssert(data.intValue(fromBit: 156, toBit: 171) == 10)
        XCTAssert(data.intValue(fromBit: 172, toBit: 172) == 0)
        XCTAssert(data.intValue(fromBit: 173, toBit: lastBit) == 0)
    }
    
    func testConsentStringLanguage () {
        let consentString = try!ConsentString(consentString: "BOMexSfOMexSfAAABAENAAAAAAAAoAA")
        XCTAssert(consentString.consentLanguage == "EN", consentString.consentLanguage)
    }
    
    func testPurposesAllowed () {
        let consentStringArray = ["BOMexSfOMexSfAAABAENAA////AAoAA",
                                  "BOMexSfOMexSfAAABAENAAf///AAoAA",
                                  "BOMexSfOMexSfAAABAENAAP///AAoAA",
                                  "BOMexSfOMexSfAAABAENAAH///AAoAA",
                                  "BOMexSfOMexSfAAABAENAAD///AAoAA",
                                  "BOMexSfOMexSfAAABAENAAB///AAoAA",
                                  "BOMexSfOMexSfAAABAENAAA///AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAf//AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAP//AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAH//AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAD//AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAB//AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAA//AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAf/AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAP/AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAH/AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAD/AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAB/AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAA/AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAAfAAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAAPAAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAAHAAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAADAAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAABAAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAAAAAoAA"]
        var consentString:ConsentString
        var purposesAllowed:[Int8]
        for (index,string) in consentStringArray.enumerated() {
            consentString = try!ConsentString(consentString: string)
            purposesAllowed = consentString.purposesAllowed
            if index < 24 {
                for i in index+1...24 {
                    XCTAssert(purposesAllowed.contains(Int8(i)))
                }
            }
            for i in 0..<index {
                XCTAssert(!purposesAllowed.contains(Int8(i+1)))
            }
        }
        
    }
    
    func testVendorAllowed() {
        
        let consentStringArray = [
            "BOM03lPOM03lPAAABAENAAAAAAABSABAAcA",
            "BOM03lPOM03lPAAABAENAAAAAAABTABAAcA",
            "BOM03lPOM03lPAAABAENAAAAAAAChAAAAAAI",
            "BOM03lPOM03lPAAABAENAAAAAAACg//////w",
            "BOM03lPOM03lPAAABAENAAAAAAADiADgACAB0AFAAoABwA",
            "BOM03lPOM03lPAAABAENAAAAAAAAzADgACAB0AFAAoABwA",
            "BOM03lPOM03lPAAABAENAAAAAAADg8AAAAAAAAA",
            "BOM03lPOM03lPAAABAENAAAAAAAAwCAA"
        ]
        let testVendors:[([[Int]],[[Int]])] = [//array of tuples of array of allowed ranges and not allowed ranges
            ([[14,14]],[[0,13],[15,300]]),
            ([[1,13],[15,20]],[[14,14],[21,300]]),
            ([[1,1],[40,40]],[[2,39]]),
            ([[2,39]],[[1,1],[40,40]]),
            ([[1,14],[20,40],[56,56]],[[15,19],[41,55],[57,200]]),
            ([],[[1,200]]),
            ([[2,5]],[[1,1],[6,200]]),
            ([[6,6]],[[1,5],[7,200]])
        ]
        var consentString:ConsentString
        for (index,string) in consentStringArray.enumerated() {
            consentString = try!ConsentString(consentString: string)
            let vendorsAllowedRanges = testVendors[index].0
            for vendorRange in vendorsAllowedRanges {
                for vendor in vendorRange[0]...vendorRange[1] {
                    XCTAssert(consentString.isVendorAllowed(vendorId: vendor), "vendor \(vendor) not allowed!")
                }
            }
            let vendorsNotAllowedRanges = testVendors[index].1
            for vendorRange in vendorsNotAllowedRanges {
                for neggedVendor in vendorRange[0]...vendorRange[1] {
                    XCTAssert(!consentString.isVendorAllowed(vendorId: neggedVendor), "negged vendor \(neggedVendor) IS allowed!")
                    
                }
            }
        }
    }
    
    func testConsentScreen () {
        let consentStrings = [
            "BN5lERiOMYEdiAOAWeFRAAYAAaAAptQ",
            "BON0avfON0avfAAABAENAAAAAAAAoAA",
            "BON0avfON0avfAAAB/ENAAAAAAAAoAA",
            "BON0avfON0avfAAABfENAAAAAAAAoAA",
            "BON0avfON0avfAAABPENAAAAAAAAoAA",
            "BON0avfON0avfAAABHENAAAAAAAAoAA",
            "BON0avfON0avfAAABDENAAAAAAAAoAA",
            "BON0avfON0avfAAABBENAAAAAAAAoAA"
        ]
        let values = [
            30,
            0,
            63,
            31,
            15,
            7,
            3,
            1
        ]
        for (index,string) in consentStrings.enumerated() {
            let consentString = try!ConsentString(consentString: string.base64Padded)
            XCTAssert(consentString.consentScreen == values[index], "Actual screen: \(consentString.consentScreen)")
        }
    }
    
    func binaryStringRepresenting(data:Data) -> String {
        return  data.reduce("") { (acc, byte) -> String in
            let stringRep = String(byte, radix: 2)
            let pad = 8 - stringRep.count
            let padString = "".padding(toLength: pad, withPad: "0", startingAt: 0)
            return acc + padString + stringRep
        }
    }
    
    func binary(string:String, isEqualToBinaryString string2:String) -> Bool {
        if abs(string.count - string2.count) > 7 {
            return false
        }
        var index = 0
        var max = string.count
        if string.count > string2.count {
            max = string2.count
        }
        while index < max {
            if string[string.index(string.startIndex, offsetBy: index)] != string2[string2.index(string2.startIndex, offsetBy: index)] {
                return false
            }
            index += 1
        }
        if string.count > string2.count {
            while index < string.count {
                if string[string.index(string.startIndex, offsetBy: index)] != "0" {
                    return false
                }
                index += 1
            }
        } else {
            while index < string2.count {
                if string2[string2.index(string2.startIndex, offsetBy: index)] != "0" {
                    return false
                }
                index += 1
            }
        }
        return true
    }
    
}
