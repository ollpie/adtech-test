//
//  NetworkConfig.swift
//  SOMHeaderbiddingSDK
//
//  Created by Julian Brehm on 29.01.19.
//  Copyright © 2019 SevenOne Media. All rights reserved.
//
import SOMCore
/** Properties available in all networks. */
internal class NetworkConfig {
    internal struct Defaults {
        internal static let enabled: Bool = true // Enables or disables network.
        internal static let ttl: Int = 300 // Sets how long bid should be valid before it expires in seconds.
        internal static let stackSize: Int = 1 // Allows to request multiple bids per slot
        internal static let testing: Bool = false // Enables SDK testing mode if available.
        internal static let debug: Bool = false // Enables SDK debug logs if available.
        internal static let pricePoint: String = "nobucket" // Enables SDK debug logs if available.
    }
    internal var logBreadcrumbs: [String] =
        [String(describing: HeaderBiddingSDK.self), String(describing: NetworkConfig.self)]
    internal var enabled: Bool = Defaults.enabled
    internal var ttl: Int =  Defaults.ttl
    internal var stackSize: Int = Defaults.stackSize
    internal var testing: Bool = Defaults.testing
    internal var debug: Bool = Defaults.debug
    internal var pricePoint: String = Defaults.pricePoint
    internal init?(_ data: [String: Any]) {
        // Optional values
        self.enabled = data["enabled"] as? Bool ?? self.enabled
        self.ttl = data["ttl"] as? Int ?? self.ttl
        self.stackSize = data["stackSize"] as? Int ?? self.stackSize
        self.testing = data["testing"] as? Bool ?? self.testing
        self.debug = data["debug"] as? Bool ?? self.debug
        self.pricePoint = data["pricePoint"] as? String ?? self.pricePoint
        SOMLogger.log(.debug, self.logBreadcrumbs, "enabled %@", [String(describing: self.enabled)])
        SOMLogger.log(.debug, self.logBreadcrumbs, "ttl %@", [String(describing: self.ttl)])
        SOMLogger.log(.debug, self.logBreadcrumbs, "testing %@", [String(describing: self.testing)])
        SOMLogger.log(.debug, self.logBreadcrumbs, "debug %@", [String(describing: self.debug)])
        SOMLogger.log(.debug, self.logBreadcrumbs, "pricePoint %@", [String(describing: self.pricePoint)])
    }
}
