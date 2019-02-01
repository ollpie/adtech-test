//
//  YieldProbeConfig.swift
//  SOMHeaderbiddingSDK
//
//  Created by Julian Brehm on 2018-09-28.
//  Copyright © 2018 SevenOne Media. All rights reserved.
//
import SOMCore
internal final class YieldProbeNetworkConfig: NetworkConfig {
    internal var slots: [YieldProbeSlotConfig] = []
    internal override init?(_ data: [String: Any]) {
        guard let yieldProbeConfig = data["yieldProbe"] as? [String: Any] else {
            return nil
        }
        super.init(yieldProbeConfig) // Check global network parameters
        self.logBreadcrumbs =
            [String(describing: HeaderBiddingSDK.self), String(describing: YieldProbeNetworkConfig.self)]
        guard let slots = yieldProbeConfig["slots"] as? [Any] else {
            SOMLogger.log(.force, self.logBreadcrumbs,
                          "YieldProbe slots are not in the expected format.")
            return nil
        }
        for slotAny in slots {
            // Check if slot is available in configuration
            guard let slot = slotAny as? [String: Any] else {
                SOMLogger.log(.force, self.logBreadcrumbs,
                              "YieldProbe slot data is not in the expected format.")
                continue // Try next slot
            }
            // Try to instanciate slot object
            guard let slotObject = YieldProbeSlotConfig(slot) else {
                continue // Try next slot
            }
            self.slots.append(slotObject)
        }
        SOMLogger.log(.debug, self.logBreadcrumbs, "slots %@", [String(describing: self.slots)])
    }
}
