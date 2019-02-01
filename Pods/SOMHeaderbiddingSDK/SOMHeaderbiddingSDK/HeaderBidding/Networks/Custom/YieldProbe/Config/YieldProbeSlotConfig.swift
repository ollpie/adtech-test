//
//  YieldProbeSlotConfig.swift
//  SOMHeaderbiddingSDK
//
//  Created by Julian Brehm on 29.01.19.
//  Copyright © 2019 SevenOne Media. All rights reserved.
//
import SOMCore
internal class YieldProbeSlotConfig: SlotConfig {
    internal var targetingIdentifier: String! // Targeting parameter used in GAM, e.g. mb1, ml1, rt1...
    internal override init?(_ data: [String: Any]) {
        super.init(data) // Check global slot parameters
        self.logBreadcrumbs =
            [String(describing: HeaderBiddingSDK.self), String(describing: YieldProbeSlotConfig.self)]
        self.targetingIdentifier = data["targetingIdentifier"] as? String ?? self.targetingIdentifier
        SOMLogger.log(.debug, self.logBreadcrumbs, "targetingIdentifier %@", [String(describing: self.targetingIdentifier)])
    }
}
