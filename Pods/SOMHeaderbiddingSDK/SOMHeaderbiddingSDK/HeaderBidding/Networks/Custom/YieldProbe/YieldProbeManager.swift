//
//  SOMBid.swift
//  SOMHeaderbiddingSDK
//
//  Created by Julian Brehm on 2018-07-24.
//  Copyright © 2018 SevenOne Media. All rights reserved.
//

import Foundation
import SOMCore

internal class YieldProbeManager: NetworkManager {
    // MARK: Internal functions
    init?(_ data: [String : Any], offset: Int) {
        super.init()
        self.logBreadcrumbs = [String(describing: HeaderBiddingSDK.self), String(describing: YieldProbeManager.self)]
        guard let config = YieldProbeNetworkConfig(data) else {
            SOMLogger.log(.force, self.logBreadcrumbs, "Abort, network config not valid.")
            return nil
        }
        if !config.enabled {
            SOMLogger.log(.debug, self.logBreadcrumbs, "Abort, network is disabled via config.")
            return nil
        }
        self.lifetimeOfBidInSeconds = config.ttl - offset
        self.pricePoint = config.pricePoint
        self.stackSize = config.stackSize
        self.registerSlots(slots: config.slots)
        SOMLogger.log(.developer, self.logBreadcrumbs, "Network initialized.")
    }
    // MARK: Private functions
    private func registerSlots(slots: [YieldProbeSlotConfig]) {
        for slot in slots {
            if !slot.enabled {
                SOMLogger.log(.debug, self.logBreadcrumbs + [slot.name], "Slot is disabled via config.")
                continue
            }
            let yieldProbeSlot = NetworkSlot()
            yieldProbeSlot.name = slot.name
            yieldProbeSlot.identifier = slot.identifier
            yieldProbeSlot.type = slot.type
            yieldProbeSlot.targetingIdentifier = slot.targetingIdentifier
            yieldProbeSlot.priceBuckets = slot.priceBuckets
            yieldProbeSlot.productId = slot.productId
            self.registerSlot(yieldProbeSlot)
        }
    }
    // MARK: Internal override functions
    /** This function returns a request task for the YieldProbe network. */
    internal override func getSpecificNetworkRequest(_ slot: NetworkSlot) -> RequestTask {
        let request = YieldProbeRequestTask()
        request.setSlot(slot)
        return request
    }
    /** The YieldProbe network requires a mapping between server response and targeting.
     Therefore, this function is overridden. */
    internal override func getTargeting(_ slotName: String) -> [String: String] {
        guard let bid = self.extractBidFromStack(slotName: slotName) else {
            SOMLogger.log(.developer, self.logBreadcrumbs + [slotName], "Bid could not be extracted.")
            return [String: String]()
        }
        guard let slot = self.slots[slotName] else {
            SOMLogger.log(.developerError, self.logBreadcrumbs + [slotName], "Slot not found.")
            return [String: String]()
        }
        // Extracxt needed values from parameter list
        guard let pid = bid.parameter[YieldProbeStaticConfig.ResponseKey.pid] else {
            SOMLogger.log(.developerError, self.logBreadcrumbs + [slotName],
                          "Key >%@< is undefined: %@",
                          [YieldProbeStaticConfig.ResponseKey.pid, String(describing: bid.parameter)])
            return [String: String]()
        }
        guard let pvid = bid.parameter[YieldProbeStaticConfig.ResponseKey.pvid] else {
            SOMLogger.log(.developerError, self.logBreadcrumbs + [slotName],
                          "Key >%@< is undefined: %@",
                          [YieldProbeStaticConfig.ResponseKey.pvid, String(describing: bid.parameter)])
            return [String: String]()
        }
        guard let identifier = slot.identifier else {
            SOMLogger.log(.developerError, self.logBreadcrumbs + [slotName],
                          "Slot >identifier< is undefined: %@", [String(describing: bid.parameter)])
            return [String: String]()
        }
        // Generate targeting
        var targeting =  [YieldProbeStaticConfig.AdManagerRequestKey.aid: String(describing: identifier),
                          YieldProbeStaticConfig.AdManagerRequestKey.pid: pid,
                          YieldProbeStaticConfig.AdManagerRequestKey.pvid: pvid]
        // Add optional values to targeting
        if let priorityValue = self.generatePriorityValue(bid: bid, slot: slot) {
            targeting[YieldProbeStaticConfig.AdManagerRequestKey.ylb] = priorityValue
            SOMLogger.log(.developerError, self.logBreadcrumbs + [slotName],
                          "Added priority to targeting.")
        }
        if let pricePointValue = self.generatePricePointValue(bid: bid, slot: slot) {
            targeting[YieldProbeStaticConfig.AdManagerRequestKey.pricePoint] = pricePointValue
            SOMLogger.log(.debug, self.logBreadcrumbs,
                          "Added price point to targeting.")
        }
        return targeting
    }
    // MARK: Private functions
    /** Generate priority for line item targeting in ad manager, replaced by price points */
    private func generatePriorityValue(bid: NetworkBid, slot: NetworkSlot) -> String? {
        guard let prio = bid.parameter[YieldProbeStaticConfig.ResponseKey.prio] else {
            SOMLogger.log(.debug, self.logBreadcrumbs,
                          "Prio not generated, >prio< missing.")
            return nil
        }
        guard let targetingIdentifier = slot.targetingIdentifier else {
            SOMLogger.log(.debug, self.logBreadcrumbs,
                          "Prio not generated, >targetingIdentifier< missing.")
            return nil
        }
        return String(format: "%@,%@p%@", targetingIdentifier, targetingIdentifier, prio)
    }
    /** Generate price bucket string */
    internal func generatePricePointValue(bid: NetworkBid, slot: NetworkSlot) -> String? {
        guard let productId = slot.productId else {
            SOMLogger.log(.debug, self.logBreadcrumbs,
                          "Price point not generated, >productId< missing.")
            return nil
        }
        guard let priceBuckets = slot.priceBuckets else {
            SOMLogger.log(.debug, self.logBreadcrumbs,
                          "Price point not generated, price buckets missing.")
            return nil
        }
        guard let price = bid.parameter[YieldProbeStaticConfig.ResponseKey.price] else {
            SOMLogger.log(.debug, self.logBreadcrumbs,
                          "Price point not generated, >price< missing.")
            return nil
        }
        guard let priceNumber = NumberFormatter().number(from: price) else {
            SOMLogger.log(.debug, self.logBreadcrumbs,
                          "Price point not generated, >price< is not a number.")
            return nil
        }
        if let priceBucket = self.getPricePoint(price: priceNumber.intValue, priceBuckets: priceBuckets) {
            return String(format: "%@_%i", productId, priceBucket)
        }
        return String(format: "%@_%@", productId, self.pricePoint)
    }
}
