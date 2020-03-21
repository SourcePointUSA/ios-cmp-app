//
//  ConnectivityManagerSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Vilas on 20/03/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import ConsentViewController

class ConnectivityManagerSpec: QuickSpec {
    
    override func spec() {
        
        describe("Test ConnectivityManager") {
            
            it("Test isConnectedToNetwork method") {
                let networkStatus = ConnectivityManager.shared.isConnectedToNetwork()
                if networkStatus == true {
                    expect(networkStatus).to(equal(true), description: "Device is connected to internet")
                }else {
                    expect(networkStatus).to(equal(true), description: "Device is not connected to internet")
                }
            }
            
            it("Test getConnectivityFlags method") {
                let connectivityFlags = ConnectivityManager.shared.getConnectivityFlags()
                if let flags = connectivityFlags {
                    expect(flags).notTo(beNil(), description: "Able to get network connectivity flags")
                }else {
                    expect(connectivityFlags).to(beNil(), description: "Unable to get network connectivity flags")
                }
            }
            
            it("Test ipv6Connectivity method") {
                let networkReachabilityAddress = ConnectivityManager.shared.ipv6Connectivity()
                if let networkAddress = networkReachabilityAddress {
                    expect(networkAddress).notTo(beNil(), description: "Able to get network connectivity address/name")
                }else {
                    expect(networkReachabilityAddress).to(beNil(), description: "Unable to get network connectivity address/name")
                }
            }
            
            it("Test ipv4Connectivity method") {
                let networkReachabilityAddress = ConnectivityManager.shared.ipv4Connectivity()
                if let networkAddress = networkReachabilityAddress {
                    expect(networkAddress).notTo(beNil(), description: "Able to get network connectivity address/name")
                }else {
                    expect(networkReachabilityAddress).to(beNil(), description: "Unable to get network connectivity address/name")
                }
            }
        }
    }
}
