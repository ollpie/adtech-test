//
//  SOMConnectivityManager.swift
//  SOMCore
//
//  Created by Julian Brehm on 2018-07-24.
//  Copyright © 2018 SevenOne Media. All rights reserved.
//

import Foundation
import CoreTelephony
import SystemConfiguration

/** Manager for connectivity information used by all SOM SDKs. */
public final class SOMConnectivityManager {
    // MARK: Public static functions:
    public static var shared = SOMConnectivityManager() // Singleton
    // MARK: internal variables:
    internal let assumeConnectionIfUnknown = true
    internal var logBreadcrumbs: [String] = [String(describing: SOMConnectivityManager.self)]
    internal var reachability: SCNetworkReachability?
    internal enum Status: String, CustomStringConvertible {
        case unreachable, wifi, wwan, unknown
        var description: String {
            return rawValue
        }
    }
    // MARK: Public functions:
    init() {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let reachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }}) else {
                SOMLogger.log(.developerError, logBreadcrumbs, "Unknown error while requesting connection state.")
                return
            }
        self.reachability = reachability
    }
    public func setup() {
        SOMLogger.log(.developer, self.logBreadcrumbs, "Singleton created.")
    }
    public var networkConnected: Bool {
        if status == .unknown {
            return self.assumeConnectionIfUnknown
        }
        if status == .unreachable {
            return false
        }
        return true
    }
    public var connectionType: Int {
        switch status {
        case .wifi:
            SOMLogger.log(.developer, logBreadcrumbs, "Reachable via WIFI.")
            return SOMStaticConfig.networkWifi
        case .wwan:
            SOMLogger.log(.developer, logBreadcrumbs, "Reachable via WWAN.")
            return cellularConnectionType
        case .unreachable:
            SOMLogger.log(.developer, logBreadcrumbs, "Not reachable.")
            return SOMStaticConfig.networkUnknown
        case .unknown:
            SOMLogger.log(.developer, logBreadcrumbs, "Unknown network state.")
            return SOMStaticConfig.networkUnknown
        }
    }
    // MARK: Internal variables
    internal var status: Status {
        if flags == nil {
            return .unknown
        }
        return !connectedToNetwork ? .unreachable : (reachableViaWiFi ? .wifi : .wwan)
    }
    internal var flags: SCNetworkReachabilityFlags? {
        guard let reachability = reachability else {
            return nil
        }
        var flags = SCNetworkReachabilityFlags()
        return withUnsafeMutablePointer(to: &flags) {
            SCNetworkReachabilityGetFlags(reachability, UnsafeMutablePointer($0))
            } ? flags : nil
    }
    internal var connectedToNetwork: Bool {
        return reachable && !connectionRequiredAndTransientConnection
    }
    internal var reachableViaWiFi: Bool {
        return reachable && !isWWAN
    }
    internal var reachable: Bool {
        return flags!.contains(.reachable)
    }
    internal var isWWAN: Bool {
        return flags!.contains(.isWWAN)
    }
    internal var connectionRequiredAndTransientConnection: Bool {
        return (flags!.intersection([.connectionRequired, .transientConnection])
            == [.connectionRequired, .transientConnection])
    }
    internal var cellularConnectionType: Int {
        switch CTTelephonyNetworkInfo().currentRadioAccessTechnology {
        case CTRadioAccessTechnologyGPRS:
            return SOMStaticConfig.network2g
        case CTRadioAccessTechnologyCDMA1x:
            return SOMStaticConfig.network2g
        case CTRadioAccessTechnologyEdge:
            return SOMStaticConfig.network2komma5g
        case CTRadioAccessTechnologyWCDMA:
            return SOMStaticConfig.network3g
        case CTRadioAccessTechnologyCDMAEVDORev0:
            return SOMStaticConfig.network3g
        case CTRadioAccessTechnologyCDMAEVDORevA:
            return SOMStaticConfig.network3g
        case CTRadioAccessTechnologyCDMAEVDORevB:
            return SOMStaticConfig.network3g
        case CTRadioAccessTechnologyeHRPD:
            return SOMStaticConfig.network3g
        case CTRadioAccessTechnologyHSDPA:
            return SOMStaticConfig.network3komma5g
        case CTRadioAccessTechnologyHSUPA:
            return SOMStaticConfig.network3komma5g
        case CTRadioAccessTechnologyLTE:
            return SOMStaticConfig.network4g
        default:
            return SOMStaticConfig.networkUnknownWwan
        }
    }
}
