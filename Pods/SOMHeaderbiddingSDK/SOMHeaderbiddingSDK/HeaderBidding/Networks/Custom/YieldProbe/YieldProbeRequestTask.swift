//
//  YieldProbeRequsetTask+.swift
//  SOMHeaderbiddingSDK
//
//  Created by Julian Brehm on 2018-09-05.
//  Copyright © 2018 SevenOne Media. All rights reserved.
//

import Foundation
import SOMCore

class YieldProbeRequestTask: RequestTask {
    // MARK: Internal functions
    override init() {
        super.init()
        self.logBreadcrumbs =
            [String(describing: HeaderBiddingSDK.self), String(describing: YieldProbeRequestTask.self)]
    }
    /** There is no YieldProbe bid SDK. This functionality was implemeted by SOM.
     The callback is handled by a complemtion handler. */
    internal override func startRequest() {
        YieldProbeRequest.requestBidFor(self.slot) { (bidParameter: [String: String]?) in
            if bidParameter == nil {
                SOMLogger.log(.developer, self.logBreadcrumbs + [self.slot.name], "No data received.")
            } else {
                SOMLogger.log(.response, self.logBreadcrumbs + [self.slot.name],
                              "Data received: %@", [String(describing: bidParameter)])
            }
            self.isRequesting = false
            self.delegate?.bidReceived(bidParameter: bidParameter, slot: self.slot)
            return
        }
    }
}
