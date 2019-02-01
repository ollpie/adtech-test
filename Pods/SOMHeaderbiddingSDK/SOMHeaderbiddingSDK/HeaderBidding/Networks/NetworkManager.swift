//
//  NetworkManager.swift
//  SOMHeaderbiddingSDK
//
//  Created by Julian Brehm on 2018-09-04.
//  Copyright © 2018 SevenOne Media. All rights reserved.
//

import Foundation
import SOMCore

internal class NetworkManager: RequestTaskDelegate {
    // MARK: Internal variables
    internal var logBreadcrumbs: [String] =
        [String(describing: HeaderBiddingSDK.self), String(describing: NetworkManager.self)]
    internal var slots: [String: NetworkSlot] = [String: NetworkSlot]() // Information about each slot
    internal var bids: [String: [NetworkBid]] = [String: [NetworkBid]]() // List with bids for each slot -> stackSize
    internal var requestTasks: [String: RequestTask] = [String: RequestTask]() // Request task for each slot
    internal var numberOfPendingRequests = 0 // This variable is mainly for testing
    internal var stackSize: Int! // How many bids can be hold on a stack
    internal var lifetimeOfBidInSeconds: Int! // How long is a bid valid
    internal var pricePoint: String!
    // MARK: Internal delegate functions
    /** This function is called via delegate from request task. */
    internal func bidReceived(bidParameter: [String: String]?, slot: NetworkSlot?) {
        self.numberOfPendingRequests -= 1
        guard let slot = slot else {
            SOMLogger.log(.developer, self.logBreadcrumbs, "Error requesting bid..")
            return
        }
        guard let bidParameter = bidParameter else {
            SOMLogger.log(.developer, self.logBreadcrumbs, "No bid received.")
            return
        }
        SOMLogger.log(.developer, self.logBreadcrumbs, "Success, bid received.")
        guard let lifetimeOfBidInSeconds = self.lifetimeOfBidInSeconds else {
            SOMLogger.log(.developerError, self.logBreadcrumbs, "Error, >lifetimeOfBidInSeconds< is undefined.")
            return
        }
        let bid = NetworkBid(bidParameter, lifetimeInSeconds: lifetimeOfBidInSeconds)
        self.addBidToBidStack(slotName: slot.name, bid: bid)
    }
    // MARK: Internal inferface functions
    /** Check slot and add it to list. */
    internal func registerSlot(_ slot: NetworkSlot) {
        if self.slots[slot.name] != nil {
            SOMLogger.log(.developerError, self.logBreadcrumbs + [slot.name],
                          "Slot cannot be registered, name is ambiguous.")
            return
        }
        self.slots[slot.name] = slot
        // Create request task for specific network via override function
        guard let request = self.getSpecificNetworkRequest(slot) else {
            SOMLogger.log(.developerError, self.logBreadcrumbs + [slot.name],
                          "Abort, no request function implemented for this network class.")
            return
        }
        request.delegate = self // Use callback functions of this class
        self.requestTasks[slot.name] = request
        SOMLogger.log(.developer, self.logBreadcrumbs + [slot.name], "Slot successfully registered.")
    }
    /** Try to request bid for slot. */
    internal func updateSlot(_ slotName: String) {
        if !SOMConnectivityManager.shared.networkConnected {
            SOMLogger.log(.developer, self.logBreadcrumbs + [slotName], "Device is not connected to the internet.")
            return
        }
        SOMLogger.log(.developer, self.logBreadcrumbs + [slotName], "Try to update slot.")
        guard let slot = self.slots[slotName] else {
            SOMLogger.log(.developerError, self.logBreadcrumbs + [slotName], "Do not update, slot is undefined.")
            return
        }
        if let bidStack = self.bids[slotName], let bid = bidStack.first, !bid.isExpired {
            SOMLogger.log(.developer, self.logBreadcrumbs + [slot.name], "Do not update, bid expires in %@ minutes.",
                          [String(describing: bid.remainingLifetime)])
            return
        }
        self.startRequest(slotName)
    }
    /** Try to get bids for all slots. */
    internal func updateAllSlots() {
        if !SOMConnectivityManager.shared.networkConnected {
            SOMLogger.log(.developer, self.logBreadcrumbs, "Device is not connected to the internet.")
            return
        }
        SOMLogger.log(.developer, self.logBreadcrumbs,
                      "Try to update slots >%@<", [String(describing: self.slots.keys)])
        var slotsToUpdate = [String]()
        for (slotName, slot) in self.slots {
            if let bidStack = self.bids[slotName], let bid = bidStack.first, !bid.isExpired {
                SOMLogger.log(.developer, self.logBreadcrumbs + [slot.name],
                              "Do not update, bid expires in %@ minutes.",
                              [String(describing: bid.remainingLifetime)])
                return
            }
            slotsToUpdate.append(slot.name)
        }
        if slotsToUpdate.count < 1 {
            SOMLogger.log(.developer, self.logBreadcrumbs, "Do not update, no bids in request queue.")
            return
        }
        self.startRequests(slotsToUpdate)
    }
    /** Return parameter as targeting. Override this function if a mapping is required. */
    internal func getTargeting(_ slotName: String) -> [String: String] {
        guard let bidStack = self.bids[slotName] else {
            SOMLogger.log(.developer, self.logBreadcrumbs + [slotName], "No bid stack found.")
            return [String: String]()
        }
        guard let bid = bidStack.first else {
            SOMLogger.log(.developer, self.logBreadcrumbs + [slotName], "No bids in stack.")
            return [String: String]()
        }
        self.deleteFirstBidFromStack(slotName)
        return bid.parameter
    }
    /** Map price to price bucket */
    internal func getPricePoint(price: Int, priceBuckets: [SOMPriceBucket]) -> Int? {
        for bucket in priceBuckets {
            if bucket.contains(price) {
                return bucket.pricePoint(price)
            }
        }
        return nil
    }
    // MARK: Internal functions
    /** Add bid to list and drop the oldest bid if stack is full. */
    internal func addBidToBidStack(slotName: String, bid: NetworkBid) {
        guard let stackSize = self.stackSize else {
            SOMLogger.log(.developerError, self.logBreadcrumbs + [slotName], "Stack size is undefined.")
            return
        }
        var bidStack = self.bids[slotName] ?? [NetworkBid]() // Create new stack if stack is undefined
        SOMLogger.log(.developer, self.logBreadcrumbs + [slotName], "Current stack size: %@/%@",
                      [String(describing: bidStack.count), String(describing: stackSize)])
        if bidStack.count >= stackSize {
            bidStack.remove(at: 0) // Remove the oldes bid in the list
            SOMLogger.log(.developer, self.logBreadcrumbs + [slotName], "Bid stack full, removed oldest bid.")
        }
        bidStack.append(bid) // Ad the new bid to the list
        self.bids[slotName] = bidStack
        SOMLogger.log(.developer, self.logBreadcrumbs + [slotName], "Bid added to stack.")
    }
    /** Extract bid. */
    internal func extractBidFromStack(slotName: String) -> NetworkBid? {
        guard let bidStack = self.bids[slotName] else {
            SOMLogger.log(.developer, self.logBreadcrumbs + [slotName], "No bid stack found.")
            return nil
        }
        guard let bid = bidStack.first else {
            SOMLogger.log(.developer, self.logBreadcrumbs + [slotName], "No bids in stack.")
            return nil
        }
        self.deleteFirstBidFromStack(slotName)
        return bid
    }
    /** Delete the oldest bid in the stack. */
    internal func deleteFirstBidFromStack(_ slotName: String) {
        guard var bidStack = self.bids[slotName] else {
            SOMLogger.log(.developer, self.logBreadcrumbs + [slotName], "No bids found in stack.")
            return
        }
        bidStack.remove(at: 0) // What happens is no bids in stack? @toTest
        self.bids[slotName] = bidStack
        SOMLogger.log(.developer, self.logBreadcrumbs + [slotName], "First bid removed.")
    }
    // MARK: Internal override functions
    /** Start request task for a single slot. */
    internal func startRequest(_ slotName: String) {
        SOMLogger.log(.developer, self.logBreadcrumbs + [slotName], "Start request task asynchronous.")
        DispatchQueue.global().sync { // SIGNALABORT 'Invalid DTBAdSize passed to the request.', reason: 'Invalid DTBAdSize passed to the request.'
            guard let request = self.requestTasks[slotName] else {
                return
            }
            if request.start() {
                self.numberOfPendingRequests += 1
            }
        }
    }
    /** Start request task for all slots in the array. */
    internal func startRequests(_ slotsToUpdate: [String]) {
        SOMLogger.log(.developer, self.logBreadcrumbs, "Start all request tasks asynchronous.")
        DispatchQueue.global().sync {
            for slotName in slotsToUpdate {
                guard let request = self.requestTasks[slotName] else {
                    continue
                }
                if request.start() {
                    self.numberOfPendingRequests += 1
                }
            }
        }
    }
    // MARK: Internal override functions
    /** This function must be overridden in the inherited class.
     It must return a request task for the specific network. */
    internal func getSpecificNetworkRequest(_ slot: NetworkSlot) -> RequestTask? {
        return nil
    }
    // MARK: Test function
    /** This function is mainly for testing, returning true is no requests are performed. */
    internal func waitUntilRequestIsFinished(completion: @escaping () -> Void) {
        let background = DispatchQueue.global()
        background.async {
            repeat {} while self.numberOfPendingRequests != 0
            completion()
        }
    }
}
