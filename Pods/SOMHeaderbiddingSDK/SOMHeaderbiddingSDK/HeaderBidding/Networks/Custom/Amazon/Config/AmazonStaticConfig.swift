//
//  AmazonStaticConfig.swift
//  SOMHeaderbiddingSDK
//
//  Created by Julian Brehm on 09.01.19.
//  Copyright © 2019 SevenOne Media. All rights reserved.
//
/** This config is used by the Amazon network classes.
 It contains required and optional keys and values
 for requests and responses for Amazon and AdManager. */
internal struct AmazonStaticConfig {
    struct ResponseKey {
        static let amznSlots = "amznslots" // Slot and price point e.g. m320x50p11
        static let amznH = "amzn_h" // Amazon server e.g. aax-eu.amazon-adsystem.com
        static let amznB = "amzn_b" // Amazon hash e.g. QvMkqLtAIo1kxIsX2p7ITg0AAAFoMwJThwMAAA-qArzAzW4
    }
    struct AdManagerRequestKey {
        static let amznSlots = "amznslots"
        static let amznH = "amzn_h"
        static let amznB = "amzn_b"
    }
}
