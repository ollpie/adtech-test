//
//  AmazonSlotRemoteConfig.swift
//  SOMHeaderbiddingSDK
//
//  Created by Julian Brehm on 29.01.19.
//  Copyright © 2019 SevenOne Media. All rights reserved.
//
import SOMCore
internal class AmazonSlotConfig: SlotConfig {
    internal struct Defaults {
        internal static let width: Int = 0 // Slot size width, mandatory if type is not overlay.
        internal static let height: Int = 0 // Slot size height, mandatory if type is not overlay.
    }
    internal var width: Int = Defaults.width
    internal var height: Int = Defaults.height
    internal override init?(_ data: [String: Any]) {
        super.init(data) // Check global slot parameters
        self.logBreadcrumbs =
            [String(describing: HeaderBiddingSDK.self), String(describing: AmazonSlotConfig.self)]
        switch self.type {
        // Width & height are mandatory for banner ads
        case .banner:
            guard let widthString = data["width"] as? String,
                let width = NumberFormatter().number(from: widthString) else {
                    SOMLogger.log(.force, self.logBreadcrumbs,
                                  "Amazon ad >width< undefined or no Integer.")
                    return nil
            }
            guard let heightString = data["height"] as? String,
                let height = NumberFormatter().number(from: heightString) else {
                    SOMLogger.log(.force, self.logBreadcrumbs,
                                  "Amazon ad >height< undefined or no Integer.")
                    return nil
            }
            self.width = width.intValue
            self.height = height.intValue
        // For overlay or instream ads, width & height are optional
        default:
            if let widthString = data["width"] as? String, let width = NumberFormatter().number(from: widthString) {
                self.width = width.intValue
            }
            if let heightString = data["height"] as? String,
                let height = NumberFormatter().number(from: heightString) {
                self.height = height.intValue
            }
        }
        SOMLogger.log(.debug, self.logBreadcrumbs, "width %@", [String(describing: self.width)])
        SOMLogger.log(.debug, self.logBreadcrumbs, "height %@", [String(describing: self.height)])
    }
}
