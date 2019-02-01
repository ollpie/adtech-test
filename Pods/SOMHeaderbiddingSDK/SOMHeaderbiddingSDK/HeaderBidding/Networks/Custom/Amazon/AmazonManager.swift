//
//  AmazonAdSlot.swift
//  SOMHeaderbiddingSDK
//
//  Created by Julian Brehm on 2018-09-03.
//  Copyright © 2018 SevenOne Media. All rights reserved.
//

import Foundation
import DTBiOSSDK
import SOMCore

internal class AmazonManager: NetworkManager {
    // MARK: Internal variables
    internal var appKey: String!
    internal var testingEnabled: Bool! // This value is passed to the Amazon server enabling the test mide
    internal var debugEnabled: Bool! // This value enables the debug messages from the Amazon SDK
    // MARK: Internal functions
    /** For the Amazon SDK a shared instance / singleton is used to configure it.
     This must be done before requesting bids. */
    init?(_ data: [String : Any], offset: Int){
        super.init()
        self.logBreadcrumbs = [String(describing: HeaderBiddingSDK.self), String(describing: AmazonManager.self)]
        guard let config = AmazonNetworkConfig(data) else {
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
        self.appKey = config.appKey
        self.testingEnabled = config.testing
        self.debugEnabled = config.debug
        self.initializeAmazonSDK()
        self.registerSlots(slots: config.slots)
        SOMLogger.log(.developer, self.logBreadcrumbs, "Network initialized, DTB SDK version %@", [DTBAds.version()])
    }
    // MARK: Private functions
    private func initializeAmazonSDK() {
        let sharedInstances = DTBAds.sharedInstance()
        sharedInstances.mraidPolicy = DFP_MRAID
        sharedInstances.setAppKey(self.appKey)
        sharedInstances.useGeoLocation = true
        sharedInstances.useSecureConnection = true
        sharedInstances.testMode = self.testingEnabled
        if self.debugEnabled {
            sharedInstances.setLogLevel(DTBLogLevelAll)
        }
    }
    private func registerSlots(slots: [AmazonSlotConfig]) {
        for slot in slots {
            if !slot.enabled {
                SOMLogger.log(.debug, self.logBreadcrumbs + [slot.name], "Slot is disabled via config.")
                continue
            }
            let amazonSlot = NetworkSlot()
            amazonSlot.name = slot.name
            amazonSlot.identifier = slot.identifier
            amazonSlot.type = slot.type
            amazonSlot.width = slot.width
            amazonSlot.height = slot.height
            amazonSlot.priceBuckets = slot.priceBuckets
            amazonSlot.productId = slot.productId
            self.registerSlot(amazonSlot)
        }
    }
    // MARK: Internal interface functions
    internal func enableTesting() {
        DTBAds.sharedInstance().testMode = true
    }
    internal func enableDebug() {
        DTBAds.sharedInstance().setLogLevel(DTBLogLevelAll)
    }
    // MARK: Internal override functions
    /** This function returns a request task for the Amazon network. */
    internal override func getSpecificNetworkRequest(_ slot: NetworkSlot) -> RequestTask {
        let request = AmazonRequestTask()
        request.setSlot(slot)
        return request
    }
    /** The Amaton network requires a mapping between server response and targeting.
     Therefore, this function is overridden. */
    internal override func getTargeting(_ slotName: String) -> [String: String] {
        guard let bid = self.extractBidFromStack(slotName: slotName) else {
            SOMLogger.log(.developer, self.logBreadcrumbs + [slotName], "Bid could not be extreacted.")
            return [String: String]()
        }
        // Check if all required keys are available
        guard let amznB = bid.parameter[AmazonStaticConfig.ResponseKey.amznB] else {
            SOMLogger.log(.developerError, self.logBreadcrumbs + [slotName],
                          "Key >%@< is undefined: %@",
                          [AmazonStaticConfig.ResponseKey.amznB, String(describing: bid.parameter)])
            return [String: String]()
        }
        guard let amznH = bid.parameter[AmazonStaticConfig.ResponseKey.amznH] else {
            SOMLogger.log(.developerError, self.logBreadcrumbs + [slotName],
                          "Key >%@< is undefined: %@", [String(describing: bid.parameter)])
            return [String: String]()
        }
        guard let amznSlots = bid.parameter[AmazonStaticConfig.ResponseKey.amznSlots] else {
            SOMLogger.log(.developerError, self.logBreadcrumbs + [slotName],
                          "Key >%@< is undefined: %@", [String(describing: bid.parameter)])
            return [String: String]()
        }
        return [AmazonStaticConfig.AdManagerRequestKey.amznB: String(describing: amznB),
                AmazonStaticConfig.AdManagerRequestKey.amznH: String(describing: amznH),
                AmazonStaticConfig.AdManagerRequestKey.amznSlots: String(describing: amznSlots)]
    }
}
