//
//  ConnectivityManager.swift
//  ConsentViewController
//
//  Created by Vilas on 12/12/19.
//

import Foundation
import SystemConfiguration

final class GDPRConnectivityManager {
    
    /// Shared Instance of Connectivity manager
    static let shared = GDPRConnectivityManager()
    
    /// Private Initializer support for Shared Instance.
    private init(){}
    
    /// The specified node name or address can be reached using the current network configuration
    func isConnectedToNetwork() -> Bool {
        guard let connectivityFlags = getConnectivityFlags() else { return false }
        let isReachable = connectivityFlags.contains(.reachable)
        let needsConnection = connectivityFlags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    /// It returns flags that indicate the connectivity of a network node name or address, including whether a connection is required or not.
    private func getConnectivityFlags() -> SCNetworkReachabilityFlags? {
        guard let connectivity = ipv4Connectivity() ?? ipv6Connectivity() else {
            return nil
        }
        var connectivityFlags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(connectivity, &connectivityFlags) {
            return nil
        }
        return connectivityFlags
    }
    
    /// It determines the status of a system's current network configuration and the connectivity of a target host for IPv6.
    private func ipv6Connectivity() -> SCNetworkReachability? {
        var zeroAddress = sockaddr_in6()
        zeroAddress.sin6_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin6_family = sa_family_t(AF_INET6)
        
        return withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        })
    }
    
    /// It determines the status of a system's current network configuration and the connectivity of a target host for IPv4.
    private func ipv4Connectivity() -> SCNetworkReachability? {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        return withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        })
    }
}
