//
//  RequestTask.swift
//  SOMHeaderbiddingSDK
//
//  Created by Julian Brehm on 2018-09-06.
//  Copyright © 2018 SevenOne Media. All rights reserved.
//

import Foundation
import SOMCore

// MARK: Protocol for delegate functions
protocol RequestTaskDelegate: class {
    func bidReceived(bidParameter: [String: String]?, slot: NetworkSlot?)
}
internal class RequestTask {
    // MARK: internal variables
    internal var slot: NetworkSlot! // The request needs information about the slot
    internal var logBreadcrumbs: [String] =
        [String(describing: HeaderBiddingSDK.self), String(describing: RequestTask.self)]
    internal var isRequesting: Bool = false
    internal weak var delegate: RequestTaskDelegate? //
    // MARK: internal functions
    /** Must be called before starting the request. */
    internal func setSlot(_ slot: NetworkSlot) {
        self.slot = slot
        SOMLogger.log(.developer, self.logBreadcrumbs + [self.slot.name], "Slot successfully set.")
    }
    /** This function must be called from a network manager class.
     It starts the request for each network. */
    internal func start() -> Bool {
        if isRequesting {
            SOMLogger.log(.developer, self.logBreadcrumbs + [self.slot.name],
                          "Abort, bid is being requested at the moment.")
            return false
        }
        if self.slot == nil {
            SOMLogger.log(.developerError, self.logBreadcrumbs, "Abort, slot must be set before starting request.")
            return false
        }
        if self.delegate == nil {
            SOMLogger.log(.developerError, self.logBreadcrumbs, "Abort, delegate must be set before starting request.")
            return false
        }
        self.isRequesting = true
        SOMLogger.log(.developer, self.logBreadcrumbs + [self.slot.name], "Request task started.")
        self.startRequest()
        return true
    }
    /** In this function the unique request must be implemented in each inherited class. */
    internal func startRequest() {
        self.isRequesting = false
        SOMLogger.log(.developerError, self.logBreadcrumbs + [self.slot.name],
                      "No request function implemented for this request class.")
    }
}
