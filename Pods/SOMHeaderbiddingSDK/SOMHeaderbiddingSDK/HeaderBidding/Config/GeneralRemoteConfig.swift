//
//  RemoteConfig.swift
//  SOMHeaderbiddingSDK
//
//  Created by Julian Brehm on 2018-09-04.
//  Copyright © 2018 SevenOne Media. All rights reserved.
//

import Foundation
import SOMCore

/** In this class, the HeaderBidding config structure
 and it's default values are defined. Furthermore, the logic is defined,
 which value is mandatory or not.
 Whether a values is mandatory can change under certain circumstances.
 The config object must be initialized with a configuraton.
 If the constructor returns nil, information is missing in this configuraton. */
internal final class GeneralRemoteConfig {
    // MARK: Private variables
    internal static var logBreadcrumbs: [String] =
        [String(describing: HeaderBiddingSDK.self), String(describing: GeneralRemoteConfig.self)]
    // MARK: Internal variables
    internal var enabled: Bool = true
    internal var debug: Bool = false
    internal var logTags: [SOMLogger.LogTag] = []
    internal var offset: Int = 0
    internal var simplifiedConsent: Bool = true
    // These variables stay nil if they are not available in the configuration
    internal var yieldPorbe: YieldProbeNetworkConfig!
    internal var amazon: AmazonNetworkConfig!
    internal init?(_ data: [String: Any]) {
        // Optional values
        self.debug = data["debug"] as? Bool ?? self.debug
        self.enabled = data["enabled"] as? Bool ?? self.enabled
        self.simplifiedConsent = data["simplifiedConsent"] as? Bool ?? self.simplifiedConsent
        self.offset = data["offset"] as? Int ?? self.offset
        if let logLevels = data["logLevels"] as? [String] {
            // Log levels in config are equal to log tags in SDK
            self.logTags = SOMLogger.getLogTagsFromString(logLevels)
        }
    }
}
