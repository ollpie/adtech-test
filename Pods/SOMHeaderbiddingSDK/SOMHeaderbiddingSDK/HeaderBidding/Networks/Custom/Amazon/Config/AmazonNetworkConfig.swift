//
//  AmazonConfig.swift
//  SOMHeaderbiddingSDK
//
//  Created by Julian Brehm on 2018-09-28.
//  Copyright © 2018 SevenOne Media. All rights reserved.
//
import SOMCore
internal final class AmazonNetworkConfig: NetworkConfig {
    internal var appKey: String! // App identifier, provided by Amazon per app.
    internal var slots: [AmazonSlotConfig] = []
    internal override init?(_ data: [String: Any]) {
        guard let amazonConfig = data["amazon"] as? [String: Any] else {
            return nil
        }
        super.init(amazonConfig) // Check global network parameters
        self.logBreadcrumbs =
            [String(describing: HeaderBiddingSDK.self), String(describing: AmazonNetworkConfig.self)]
        // Application key
        guard let appKey = amazonConfig["appKey"] as? String else {
            SOMLogger.log(.force, self.logBreadcrumbs,
                          "Amazon >appKey< undefined or no String.")
            return nil
        }
        self.appKey = appKey
        // Slots
        guard let slotData = amazonConfig["slots"] as? [Any] else {
            SOMLogger.log(.force, self.logBreadcrumbs,
                          "Amazon slots not in the expected format.")
            return nil
        }
        for slotAny in slotData {
            // Check if slot is available in configuration
            guard let slot = slotAny as? [String: Any] else {
                SOMLogger.log(.force, self.logBreadcrumbs,
                              "Amazon slot data not in the expected format.")
                continue // Try next slot
            }
            // Try to instanciate slot object
            guard let slotObject = AmazonSlotConfig(slot) else {
                continue // Try next slot
            }
            self.slots.append(slotObject)
        }
        SOMLogger.log(.debug, self.logBreadcrumbs, "appKey %@", [String(describing: self.appKey)])
        SOMLogger.log(.debug, self.logBreadcrumbs, "slots %@", [String(describing: self.slots)])
   }
    
}
