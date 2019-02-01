//
//  NetworkSlot.swift
//  SOMHeaderbiddingSDK
//
//  Created by Julian Brehm on 2018-09-19.
//  Copyright © 2018 SevenOne Media. All rights reserved.
//

import SOMCore

/** Network slot class used by all network classes.
 It contains valiables for all networks. */
internal class NetworkSlot: AmazonSlot, YieldProbeSlot {
    internal var width: Int!
    internal var height: Int!
    internal var targetingIdentifier: String!
    internal var pricePointIdentifier: String!
    internal var name: String!
    internal var identifier: String!
    internal var type: SOMSlotType!
    internal var priceBuckets: [SOMPriceBucket]!
    internal var productId: String!
}
