//
//  HeaderBiddingSDK.swift
//  SOMHeaderbiddingSDK
//
//  Created by Julian Brehm on 2018-07-24.
//  Copyright © 2018 SevenOne Media. All rights reserved.
//

import Foundation
import SOMCore

public final class HeaderBiddingSDK {
    // MARK: Public static variables
    public static var shared = HeaderBiddingSDK() // Singleton
    // MARK: Public variables
    public var isInitialized: Bool = false
    // MARK: Private variables
    internal var amazonManager: AmazonManager!
    internal var yieldProbeManager: YieldProbeManager!
    internal var logBreadcrumbs = [String(describing: HeaderBiddingSDK.self)]
    // MARK: Public functions
    /**
     Initialize the HeaderBidding SDK with a config object.
     - Parameter config: Config as object type Any
     - Parameter npa: Non-personalized Ads enabled or disabled
     */
    public func initialize(_ jsonObject: Any, nonPersonalisedAdsEnabled: Bool) {
        if self.isInitialized {
            SOMLogger.log(.force, self.logBreadcrumbs, "Abort initialization, SDK is already initialized.")
            return
        }
        SOMShared.nonPersonalisedAdsEnabled = nonPersonalisedAdsEnabled
        guard let config = ConfigParser.getNormalisedConfig(jsonObject) else {
            SOMLogger.log(.force, self.logBreadcrumbs, "Abort initialization, no valid config.")
            return
        }
        self.initializeNetworkManager(config)
    }
    /**
     Initialize the HeaderBidding SDK with a config string.
     - Parameter config: Config as Json String
     - Parameter npa: Non-personalized Ads enabled or disabled
     */
    public func initialize(_ jsonString: String, nonPersonalisedAdsEnabled: Bool) {
        if self.isInitialized {
            SOMLogger.log(.force, self.logBreadcrumbs, "Abort initialization, SDK is already initialized.")
            return
        }
        SOMShared.nonPersonalisedAdsEnabled = nonPersonalisedAdsEnabled
        guard let config = ConfigParser.getNormalisedConfig(jsonString) else {
            SOMLogger.log(.force, self.logBreadcrumbs, "Abort initialization, no valid config.")
            return
        }
        self.initializeNetworkManager(config)
    }
    /** Enable or disable Non-Personalized Ads regarding GDPR. */
    public func enableNonPersonalisedAds(_ nonPersonalisedAdsEnabled: Bool) {
        SOMShared.nonPersonalisedAdsEnabled = nonPersonalisedAdsEnabled
        SOMLogger.log(.debug, self.logBreadcrumbs, "Non-personalilzed Ads %@.",
                      [nonPersonalisedAdsEnabled ? "enabled" : "disabled"])
    }
    /** Request a new bid for all configured slots if associated bid is expired. */
    public func update() {
        if !self.isInitialized {
            SOMLogger.log(.debug, self.logBreadcrumbs, "Do not update, SDK is not initialized.")
            return
        }
        self.updateAllNetworks()
    }
    /** Request a new bid for a specific slot if associated bid is expired. */
    public func update(_ slotName: String) {
        if !self.isInitialized {
            SOMLogger.log(.debug, self.logBreadcrumbs, "Do not update, SDK is not initialized.")
            return
        }
        self.updateAllNetworks(slotName: slotName)
    }
    /** Return custom targeting for GMA SDK containing bid information for configured networks. */
    public func getTargeting(_ slotName: String) -> [String: String] {
        SOMLogger.log(.developer, self.logBreadcrumbs + [slotName], "Generate targeting...")
        var targeting = [String: String]()
        // Get targeting from both networks and delete it on managers
        // Do not add amazon targeting if NPA are enabled
        if self.amazonManager != nil && !SOMShared.nonPersonalisedAdsEnabled {
            let networkTargeting = self.amazonManager.getTargeting(slotName)
            for (key, value) in networkTargeting {
                targeting[key] = value
            }
        }
        if self.yieldProbeManager != nil {
            let networkTargeting = self.yieldProbeManager.getTargeting(slotName)
            for (key, value) in networkTargeting {
                if targeting.keys.contains(key) {
                    SOMLogger.log(.force, self.logBreadcrumbs,
                                  "CRITICAL OBSERVATION: Ambiguous key in custom targeting detected: %@", [key])
                    continue
                }
                targeting[key] = value
            }
        }
        SOMLogger.log(.developer, self.logBreadcrumbs, "Return targeting: %@", [String(describing: targeting)])
        self.updateAllNetworks(slotName: slotName) // Request new bid if possible
        return targeting
    }
    /** Enable log tags to be displayed in console output. */
    public func filterLog(_ logTags: [SOMLogger.LogTag]) {
        SOMLogger.enableLogTags(logTags)
    }
    /** If debug mode is enabled, all log messages are displayed in console output. */
    public func enableDebugMode() {
        SOMLogger.displayAllLogs = true
    }
    // MARK: Internal functions
    internal func updateAllNetworks() {
        // Do not update amazon if NPA are enabled
        if self.amazonManager != nil && !SOMShared.nonPersonalisedAdsEnabled {
            self.amazonManager.updateAllSlots()
        }
        if self.yieldProbeManager != nil {
            self.yieldProbeManager.updateAllSlots()
        }
    }
    internal func updateAllNetworks(slotName: String) {
        // Do not update amazon if NPA are enabled
        if self.amazonManager != nil && !SOMShared.nonPersonalisedAdsEnabled {
            self.amazonManager.updateSlot(slotName)
        }
        if self.yieldProbeManager != nil {
            self.yieldProbeManager.updateSlot(slotName)
        }
    }
    /** The Header Bidding config object contains default values overridden with remote values. */
    internal func initializeNetworkManager(_ config: [String : Any]) {
        guard let generalRemoteContig = GeneralRemoteConfig(config) else {
            SOMLogger.log(.force, self.logBreadcrumbs, "Abort initialization, Config not valid.")
            return
        }
        if !generalRemoteContig.enabled { // Enable or disable the SDK via config
            SOMLogger.log(.debug, self.logBreadcrumbs, "Abort initialization, Header Bidding is diabled via config.")
            return
        }
        if generalRemoteContig.debug { // Enable all logs in debug mode
            SOMLogger.log(.force, self.logBreadcrumbs, "Debug mode enabled.")
            SOMLogger.displayAllLogs = true
        }
        SOMLogger.enabledLogTags = generalRemoteContig.logTags // Override log levels
        // Try to initialize networks from config
        if let manager = AmazonManager(config, offset: generalRemoteContig.offset) {
            self.amazonManager = manager
        }
        if let manager = YieldProbeManager(config, offset: generalRemoteContig.offset) {
            self.yieldProbeManager = manager
        }
        // At least one network must be initialized
        if self.amazonManager != nil || self.yieldProbeManager != nil {
            // Set up location and connectivity manager in main thread
            SOMLocationManager.shared.setup()
            SOMConnectivityManager.shared.setup()
            SOMLogger.log(.debug, self.logBreadcrumbs, "SDK is initialized.")
            self.isInitialized = true
        } else {
            SOMLogger.log(.debug, self.logBreadcrumbs, "SDK is not initialized, no network configured.")
            self.isInitialized = false
        }
    }
    // MARK: Internal static functions
    internal static func reset() {
        // Reset all singletons
        self.shared = HeaderBiddingSDK()
    }
}
