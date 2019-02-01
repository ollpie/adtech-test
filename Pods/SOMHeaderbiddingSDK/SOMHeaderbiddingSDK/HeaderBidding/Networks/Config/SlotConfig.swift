//
//  SlotConfig.swift
//  SOMHeaderbiddingSDK
//
//  Created by Julian Brehm on 29.01.19.
//  Copyright © 2019 SevenOne Media. All rights reserved.
//
import SOMCore
/** Properties available in all slots. */
internal class SlotConfig {
    internal struct Defaults {
        internal static let enabled: Bool = true // Enables or disables slot
        internal static let slotType: SOMSlotType = .banner // Slot type. Possible types are banner, overlay, instream.
    }
    internal var logBreadcrumbs: [String] =
        [String(describing: HeaderBiddingSDK.self), String(describing: SlotConfig.self)]
    internal var priceBuckets: [SOMPriceBucket]! // Several price buckets can be defined
    internal var enabled: Bool = Defaults.enabled
    internal var type: SOMSlotType = Defaults.slotType
    internal var name: String! // Slot name to identify the slot e.g. banner, rectangle, banner2
    internal var identifier: String! // Slot ID provided by the network owner
    internal var productId: String!
    internal init?(_ data: [String: Any]) {
        // Optional values
        self.productId = data["productId"] as? String ?? self.productId
        self.enabled = data["enabled"] as? Bool ?? self.enabled
        if let type = data["type"] as? String {
            let typeLow = type.lowercased()
            switch typeLow {
            case "banner".lowercased():
                self.type = .banner
            case "overlay".lowercased():
                self.type = .overlay
            case "instream".lowercased():
                self.type = .instream
            default:
                SOMLogger.log(.force, self.logBreadcrumbs,
                              "Slot >type< is unknown.")
                return nil
            }
        }
        // Identifier
        guard let identifier = data["id"] as? String else {
            SOMLogger.log(.force, self.logBreadcrumbs,
                          "Slot >id< is undefined or no String.")
            return nil
        }
        self.identifier = identifier
        // Name
        guard let name = data["name"] as? String else {
            SOMLogger.log(.force, self.logBreadcrumbs,
                          "Slot >name< is undefined or no String.")
            return nil
        }
        self.name = name
        // Get price buckets from Json config
        if let bucketsData = data["buckets"] as? [[String: Int]] {
            for bucketsDictionary in bucketsData {
                guard let step = bucketsDictionary["step"], step >= 0 else {
                    SOMLogger.log(.force, self.logBreadcrumbs,
                                  "Skip bucket, key >step< is undefined or negative.")
                    continue
                }
                let bucket = SOMPriceBucket(step: step)
                if let minimum = bucketsDictionary["min"], minimum >= 0 {
                    bucket.minimum = minimum
                }
                if let maximum = bucketsDictionary["max"], maximum >= 0 {
                    bucket.maximum = maximum
                }
                if self.priceBuckets == nil {
                    self.priceBuckets = [SOMPriceBucket]() // Instantiate dictionary if not yet
                }
                self.priceBuckets.append(bucket)
            }
        }
        SOMLogger.log(.debug, self.logBreadcrumbs, "priceBuckets %@", [String(describing: self.priceBuckets)])
        SOMLogger.log(.debug, self.logBreadcrumbs, "enabled %@", [String(describing: self.enabled)])
        SOMLogger.log(.debug, self.logBreadcrumbs, "type %@", [String(describing: self.type)])
        SOMLogger.log(.debug, self.logBreadcrumbs, "name %@", [String(describing: self.name)])
        SOMLogger.log(.debug, self.logBreadcrumbs, "identifier %@", [String(describing: self.identifier)])
        SOMLogger.log(.debug, self.logBreadcrumbs, "productId %@", [String(describing: self.productId)])
    }
}
