//
//  YieldProbeBid.swift
//  SOMHeaderbiddingSDK
//
//  Created by Julian Brehm on 2018-09-04.
//  Copyright © 2018 SevenOne Media. All rights reserved.
//

import Foundation

/** Network bid class used by all network classes.
 The class contains functions to check the state of a bid. */
internal class NetworkBid {
    // MARK: Internal variables
    internal var creationTime: NSDate!
    internal var parameter: [String: String]!
    internal var lifetimeInSeconds: Double!
    // MARK: Internal methods
    init(_ parameter: [String: String],
         lifetimeInSeconds: Int) {
        self.parameter = parameter
        self.lifetimeInSeconds = Double(lifetimeInSeconds)
        self.creationTime = NSDate()
    }
    internal var isExpired: Bool {
        return !(fabs(self.creationTime.timeIntervalSinceNow) < self.lifetimeInSeconds)
    }
    internal var remainingLifetime: Double {
        return (self.lifetimeInSeconds - fabs(self.creationTime.timeIntervalSinceNow)) / 60
    }
}
