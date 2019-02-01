//
//  SOIAdapterAmazonDTP.swift
//  SOMHeaderbiddingSDK
//
//  Created by brehmjuNL on 2018-07-04.
//  Copyright © 2018 SevenOne Media. All rights reserved.
//
import Foundation
import GoogleMobileAds
import DTBiOSSDK
import SOMCore

@objc public class SOMAdapterAmazonDTB: SOMMediationAdapter {
    let parameterKeyForAdUnit = "adUnit"
    let parameterKeyForAppKey = "appKey"
    let parameterKeyForSlotId = "slotId"
    let parameterKeyForMinPricePoint = "minPricePoint"
    let parameterKeyForDeliver = "deliver"
    let parameterKeyForShowroom = "showroom"
    override public func performAdRequest() {
        // Skip Amazon network if user has opted out of personalized ads
        if self.consentStringIsZero() {
            self.proceedWithOtherNetwork(GADErrorCode.internalError, message: "IAB consent string is zero.")
            return
        } else {
            self.buildDTBRequest()
            self.loadDTBBid()
        }
    }
    override public func setLogTag(_ logSize: GADAdSize) {
        self.width = Int(self.size.size.width)
        self.height = Int(self.size.size.height)
        self.logBreadcrumbs = [String(describing: HeaderBiddingSDK.self),
                               String(describing: SOMAdapterAmazonDTB.self),
                               String(describing: self.width),
                               String(describing: self.height)]
    }
    override public func setKeys() {
        self.requiredKeys = [self.parameterKeyForAdUnit,
                             self.parameterKeyForAppKey,
                             self.parameterKeyForSlotId]
        self.optionalKeys = [self.parameterKeyForDeliver,
                             self.parameterKeyForShowroom,
                             self.parameterKeyForMinPricePoint,
                             self.parameterKeyForDelay]
    }
    func buildDTBRequest() {
        let sharedInstances = DTBAds.sharedInstance()
        SOMLogger.log(.developer, self.logBreadcrumbs, "DTB SDK version %@", [DTBAds.version()])
        sharedInstances.mraidPolicy = DFP_MRAID
        sharedInstances.setAppKey(self.extractedParameters[self.parameterKeyForAppKey]!)
        sharedInstances.useGeoLocation = true
        sharedInstances.useSecureConnection = true
        if self.debugEnabled {
            SOMLogger.log(.developer, self.logBreadcrumbs, "DTB logging enabled.")
            sharedInstances.setLogLevel(DTBLogLevelAll)
        }
        if self.testModeEnabled {
            SOMLogger.log(.developer, self.logBreadcrumbs, "DTB test mode enabled.")
            sharedInstances.testMode = true
        }
    }
    var debugEnabled: Bool {
        return self.debug > 0
    }
    var testModeEnabled: Bool {
        return self.testing || self.debug == 2
    }
    func loadDTBBid() {
        guard let uuid = self.extractedParameters[self.parameterKeyForSlotId] else {
            self.proceedWithOtherNetwork(GADErrorCode.internalError, message: "UUID is undefined.")
            return
        }
        let width = Int(self.size.size.width)
        let height = Int(self.size.size.height)
        guard let sizeForDtb = DTBAdSize(bannerAdSizeWithWidth: width, height: height, andSlotUUID: uuid) else {
            self.proceedWithOtherNetwork(GADErrorCode.internalError, message: "Size could not be created.")
            return
        }
        let DTBloader = DTBAdLoader()
        DTBloader.setAdSizes([sizeForDtb as Any])
        SOMLogger.log(.developer, self.logBreadcrumbs, "Request DTB Bid...")
        DTBloader.loadAd(self)
    }
    func loadAdInDFP(targeting: [AnyHashable: Any]) {
        var targetingModifiable = targeting
        if let deliver = self.extractedParameters[self.parameterKeyForDeliver] {
            targetingModifiable[self.parameterKeyForDeliver] = deliver
        }
        if let showroom = self.extractedParameters[self.parameterKeyForShowroom] {
            targetingModifiable[self.parameterKeyForShowroom] = showroom
        }
        guard let adUnit = self.extractedParameters[self.parameterKeyForAdUnit] else {
            self.proceedWithOtherNetwork(GADErrorCode.internalError, message: "Ad unit is undefined")
            return
        }
        let requestDFPAd = buildDFPRequest(adUnit: adUnit, targeting: targetingModifiable)
        self.loadDFPAd(requestDFPAd)
    }
    func checkPricepoint(minPricePointString: String!, pricePointString: String!) -> Bool {
        if minPricePointString == nil {
            SOMLogger.log(.developer, self.logBreadcrumbs, "No minimum price point set.")
            return true
        }
        if pricePointString == nil {
            SOMLogger.log(.developer, self.logBreadcrumbs, "No price point set.")
            return true
        }
        guard let minPricePoint = NumberFormatter().number(from: minPricePointString) else {
            SOMLogger.log(.developer, self.logBreadcrumbs, "Minimum price point is no number.")
            return true
        }
        let ppArray = pricePointString.components(separatedBy: "p")
        guard let pricePoint = NumberFormatter().number(from: ppArray[1]) else {
            SOMLogger.log(.developer, self.logBreadcrumbs, "Price point is no number.")
            return true
        }
        SOMLogger.log(.developer, self.logBreadcrumbs, "Extracted values pricePoint=%@ and minPricePoint=%@",
                      [minPricePointString, pricePointString])
        if pricePoint.intValue < minPricePoint.intValue {
            SOMLogger.log(.developer, self.logBreadcrumbs, "Price point lower then min price point.")
            return false
        } else {
            return true
        }
    }
}
extension SOMAdapterAmazonDTB: DTBAdCallback {
    public func onFailure(_ error: DTBAdError) {
        var errorCode: GADErrorCode
        var message: String
        switch error.rawValue {
        case NETWORK_ERROR.rawValue:
            errorCode = GADErrorCode.networkError
            message = "Network error"
        case  NETWORK_TIMEOUT.rawValue:
            errorCode = GADErrorCode.timeout
            message = "Network timeout"
        case NO_FILL.rawValue:
            errorCode = GADErrorCode.noFill
            message = "No fill"
        case INTERNAL_ERROR.rawValue:
            errorCode = GADErrorCode.internalError
            message = "Internal error"
        case REQUEST_ERROR.rawValue:
            errorCode = GADErrorCode.invalidRequest
            message = "Request error"
        default:
            errorCode = GADErrorCode.invalidRequest
            message = "Invalid request"
        }
        SOMLogger.log(.developer, self.logBreadcrumbs, "DTBAdLoader callback onFailure() triggered.")
        self.proceedWithOtherNetwork(errorCode, message: message)
    }
    public func onSuccess(_ adResponse: DTBAdResponse!) {
        SOMLogger.log(.developer, self.logBreadcrumbs, "DTBAdLoader callback onSuccess() triggered.")
        // Get ad via DFP if pricepoint is ok
        let defaultPricePoints = adResponse.defaultPricePoints()
        if self.checkPricepoint(minPricePointString: self.extractedParameters[self.parameterKeyForMinPricePoint],
                                pricePointString: defaultPricePoints) {
            SOMLogger.log(.developer, self.logBreadcrumbs, "Price point check ok, request recommendation via DFP.")
            guard let targeting = adResponse.customTargetting() else {
                self.proceedWithOtherNetwork(GADErrorCode.internalError, message: "DTP targeting is nil")
                return
            }
            self.loadAdInDFP(targeting: targeting)
        } else {
            self.proceedWithOtherNetwork(GADErrorCode.noFill, message: "Amazon price point too low")
            return
        }
    }
}
