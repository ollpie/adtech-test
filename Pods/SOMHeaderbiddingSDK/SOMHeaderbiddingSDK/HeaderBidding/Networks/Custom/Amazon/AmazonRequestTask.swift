//
//  AmazonRequest.swift
//  SOMHeaderbiddingSDK
//
//  Created by Julian Brehm on 2018-09-05.
//  Copyright © 2018 SevenOne Media. All rights reserved.
//

import Foundation
import DTBiOSSDK
import SOMCore

class AmazonRequestTask: RequestTask, DTBAdCallback {
    // MARK: Internal functions
    override init() {
        super.init()
        self.logBreadcrumbs = [String(describing: HeaderBiddingSDK.self), String(describing: AmazonRequestTask.self)]
    }
    /** The DTBAdLoader is used to start the Amazon bid request.
     This loader needs a size containing the ad uuid.
     Interstitial ads do not need width and height of the ad, banner ads do.
     Instream ads are not supported yet. */
    internal override func startRequest() {
        let adLoader = DTBAdLoader()
        guard let adSize = getAdSize() else {
            SOMLogger.log(.developerError, self.logBreadcrumbs + [self.slot.name],
                          "Ad size could not be created.")
            self.isRequesting = false
            self.delegate?.bidReceived(bidParameter: nil, slot: self.slot)
            return
        }
        adLoader.setAdSizes([adSize as Any])
        adLoader.loadAd(self)
        SOMLogger.log(.developer, self.logBreadcrumbs + [self.slot.name],
                      "Amazon SDK ad loader started, waiting for delegate to be called.")
    }
    // MARK: Internal functions
    internal func getAdSize() -> DTBAdSize? {
        guard let identifier = self.slot.identifier else {
            SOMLogger.log(.developerError, self.logBreadcrumbs + [self.slot.name],
                          "Slot identifier is undefined.")
            return nil
        }
        if self.slot.type == .overlay {
            return DTBAdSize(interstitialAdSizeWithSlotUUID: identifier)
        } else if self.slot.type == .banner { // Banner, rectangle
            guard let height = self.slot.height, let width = self.slot.width else {
                SOMLogger.log(.developerError, self.logBreadcrumbs + [self.slot.name],
                              "Slot width or height is undefined.")
                return nil
            }
            if height < 0 || width < 0 || height > 9999 || width > 9999 {
                SOMLogger.log(.developerError, self.logBreadcrumbs + [self.slot.name],
                              "Slot width or height out of range (0-9999).")
                return nil
            }
            return DTBAdSize(bannerAdSizeWithWidth: Int(width),
                             height: Int(height),
                             andSlotUUID: identifier)
        } else if self.slot.type == .instream { // Instream ads @todo
            SOMLogger.log(.developer, self.logBreadcrumbs + [self.slot.name],
                          "Instream ads are not supported yet.")
            return nil
        } else {
            SOMLogger.log(.developerError, self.logBreadcrumbs + [self.slot.name],
                          "Unknown ad type")
            return nil
        }
    }
    /** Bring the format of the Amazon parameter response [AnyHashable: Any]
     to the format used in this SDK [String: String]. */
    internal func normalizeTargeting(_ data: [AnyHashable: Any]) -> [String: String]? {
        var out = [String: String]()
        for pair in data {
            let key = String(describing: pair.key)
            let value = String(describing: pair.value)
            out[key] = value
        }
        return out
    }
    // MARK: Internal callback methods
    /** The Amazon SDK uses delegates to handle its messages. */
    internal func onFailure(_ error: DTBAdError) {
        self.isRequesting = false
        if self.slot == nil {
            self.delegate?.bidReceived(bidParameter: nil, slot: nil)
            return
        }
        var message: String
        switch error.rawValue {
        case NETWORK_ERROR.rawValue:
            message = "Network error"
        case  NETWORK_TIMEOUT.rawValue:
            message = "Network timeout"
        case NO_FILL.rawValue:
            message = "No fill"
        case INTERNAL_ERROR.rawValue:
            message = "Internal error"
        case REQUEST_ERROR.rawValue:
            message = "Request error"
        default:
            message = "Invalid request"
        }
        SOMLogger.log(.developer, self.logBreadcrumbs + [self.slot.name], "Error while requesting bid: %@", [message])
        self.delegate?.bidReceived(bidParameter: nil, slot: self.slot)
    }
    internal func onSuccess(_ adResponse: DTBAdResponse!) {
        self.isRequesting = false
        if self.slot == nil {
            self.delegate?.bidReceived(bidParameter: nil, slot: nil)
            return
        }
        var bidParameter: [String: String]! = nil
        if let targeting = adResponse.customTargetting() {
            bidParameter = self.normalizeTargeting(targeting)
        }
        SOMLogger.log(.response, self.logBreadcrumbs + [self.slot.name],
                      "Data received: %@", [String(describing: bidParameter)])
        self.delegate?.bidReceived(bidParameter: bidParameter, slot: self.slot)
    }
}
