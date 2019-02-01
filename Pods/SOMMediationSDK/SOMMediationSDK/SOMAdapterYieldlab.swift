//
//  SOIAdapterYieldlab.swift
//  TestAppiOS
//
//  Created by brehmjuNL on 2018-06-18.
//  Copyright © 2018 SevenOne Media. All rights reserved.
//
import Foundation
import GoogleMobileAds
import SOMCore

@objc public class SOMAdapterYieldlab: SOMMediationAdapter {
    let parameterKeyForAdUnit = "adUnit"
    let parameterKeyForDeliver = "deliver"
    let targetingKeyForLatitude = "lat"
    let targetingKeyForLongitude = "long"
    override public func performAdRequest() {
        guard let adUnit = self.extractedParameters[self.parameterKeyForAdUnit] else {
            self.proceedWithOtherNetwork(GADErrorCode.internalError, message: "Ad unit is undefined")
            return
        }
        let targeting = self.getCustomTargeting()
        let DFPAdRequest = self.buildDFPRequest(adUnit: adUnit, targeting: targeting)
        self.loadDFPAd(DFPAdRequest)
    }
    override public func setLogTag(_ logSize: GADAdSize) {
        self.width = Int(self.size.size.width)
        self.height = Int(self.size.size.height)
        self.logBreadcrumbs = [String(describing: SOMAdapterYieldlab.self),
                               String(describing: self.width),
                               String(describing: self.height)]
    }
    override public func setKeys() {
        self.requiredKeys = [self.parameterKeyForAdUnit]
        self.optionalKeys = [self.parameterKeyForDeliver,
                             self.parameterKeyForDelay]
    }
    func getCustomTargeting() -> [AnyHashable: Any] {
        var targeting = [String: String]()
        if let deliver = self.extractedParameters[self.parameterKeyForDeliver] {
            targeting[self.parameterKeyForDeliver] = deliver
        }
        if self.customEventRequest.userLatitude != 0.0 && self.customEventRequest.userLongitude != 0.0 {
            targeting[self.targetingKeyForLatitude] = String(format: "%@", self.customEventRequest.userLatitude)
            targeting[self.targetingKeyForLongitude] = String(format: "%@", self.customEventRequest.userLongitude)
        }
        return targeting
    }
}
