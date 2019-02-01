//
//  SOMMediationAdapter.swift
//  SOMCore
//
//  Created by Julian Brehm on 2018-10-31.
//  Copyright © 2018 SevenOne Media. All rights reserved.
//

import UIKit
import GoogleMobileAds

let customEventErrorDomain: String = "com.google.CustomEvent"

open class SOMMediationAdapter: UIViewController, GADCustomEventBanner {
    public let parameterKeyForDebug = "debug"
    public let parameterKeyForTesting = "testing"
    public let parameterKeyForDelay = "delay"
    public let fallbackValueForKeyName = "fallback"
    public let fallbackValueForKeyInfo = "true"
    public let adManagerKeyForGma = "gma"
    public let adManagerValueForGma = "1"
    public let perfBannerPhone = CGSize(width: 320.0, height: 60.0)
    public let perfBannerTablet = CGSize(width: 728.0, height: 100.0)
    public let perfRectangle = CGSize(width: 300.0, height: 260.0)
    // Disable logging and testing if not defined in Ad request
    open var debug = 0
    open var testing = false
    open var extractedParameters =  [String: String]()
    open var size: GADAdSize!
    open var width: Int!
    open var height: Int!
    open var customEventRequest: GADCustomEventRequest!
    open var dimension: GADAdSize!
    open var requiredKeys: [String]!
    open var optionalKeys: [String]!
    open var DFPAdView: DFPBannerView!
    open var isFallbackAd = false
    open var delay = 0.5 // Wait this time to check if received ad is fallback ad
    open var logBreadcrumbs: [String] = []
    open weak var delegate: GADCustomEventBannerDelegate?
    open func requestAd(_ adSize: GADAdSize,
                        parameter serverParameter: String?,
                        label serverLabel: String?,
                        request: GADCustomEventRequest) {
        guard let dimension = self.getDimensionFromSize(size: adSize) else {
            self.proceedWithOtherNetwork(GADErrorCode.invalidRequest, message: "Unknown ad size")
            return
        }
        self.dimension = dimension
        self.size = adSize
        self.setLogTag(self.size)
        SOMLogger.log(.developer, self.logBreadcrumbs, "Custom event triggerd by Google Ads SDK, label=%@",
                      [serverLabel.debugDescription])
        self.customEventRequest = request
        self.setKeys()
        self.extractParams(queryString: serverParameter) // Try to extract optional and required parameter
        if self.parametersMissing(keys: self.requiredKeys) {
            self.logParameters(keys: self.requiredKeys) // Log parameter for debugging reasons
            self.proceedWithOtherNetwork(GADErrorCode.invalidRequest, message: "Required values missing")
            return
        }
        //SOMAdapterLogger.setLogLevel(self.debug) Enable debug mode in HeaderbiddingSDK if required
        SOMLogger.log(.developer, self.logBreadcrumbs,
                      "Amazon adapter of HeaderbiddingSDK is used -> debug flag is omitted.")
        SOMLogger.log(.developer, self.logBreadcrumbs, "Test mode %@.",
                      [self.testing ? "enabled" : "disabled"])
        self.logParameters(keys: self.requiredKeys + self.optionalKeys)
        self.performAdRequest()
    }
    // Ad size must be known and mapped to a standard banner size
    open func getDimensionFromSize(size: GADAdSize) -> GADAdSize? {
        var rect = CGRect()
        rect.size = CGSizeFromGADAdSize(size)
        switch rect.size {
        case CGSizeFromGADAdSize(kGADAdSizeBanner):
            return kGADAdSizeBanner
        case CGSizeFromGADAdSize(kGADAdSizeLeaderboard):
            return kGADAdSizeLeaderboard
        case CGSizeFromGADAdSize(kGADAdSizeMediumRectangle):
            return kGADAdSizeMediumRectangle
        case self.perfBannerPhone:
            return kGADAdSizeBanner
        case self.perfBannerTablet:
            return kGADAdSizeLeaderboard
        case self.perfRectangle:
            return kGADAdSizeMediumRectangle
        default:
            return nil // Ad size is unknown
        }
    }
    // @override
    open func setLogTag(_ logSize: GADAdSize) { // Set unique log tag for each network
        return
    }
    // @override
    open func setKeys() { // Set optional and required keys to be extracted from request parameter
        return
    }
    open func extractParams(queryString: String?) {
        if let kvStrings = queryString?.components(separatedBy: "&") {
            if kvStrings.count > 0 {
                for kvStr in kvStrings {
                    let keyValue = kvStr.components(separatedBy: "=")
                    if keyValue[0].lowercased() == self.parameterKeyForDebug.lowercased() {
                        self.debug = Int(keyValue[1])! // Cast to Int
                    } else if keyValue[0].lowercased() == self.parameterKeyForTesting.lowercased() {
                        self.testing = (Int(keyValue[1])! < 1) ? false : true // Cast to Bool
                    } else {
                        if self.requiredKeys.count > 0 {
                            for key1 in self.requiredKeys {
                                if keyValue[0].lowercased() == key1.lowercased() {
                                    if !keyValue[1].elementsEqual("") {
                                        self.extractedParameters[key1] = keyValue[1]
                                    }
                                }
                            }
                        }
                        if self.optionalKeys.count > 0 {
                            for key2 in self.optionalKeys {
                                if keyValue[0].lowercased() == key2.lowercased() {
                                    if !keyValue[1].elementsEqual("") {
                                        self.extractedParameters[key2] = keyValue[1]
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    // @override
    open func performAdRequest() { // Let the network perform the ad request
        return
    }
    // If the IAB consent string is zero the user has opted out of personalized ads
    open func consentStringIsZero() -> Bool {
        if let consentString = UserDefaults.standard.string(forKey: "IABConsent_ConsentString") {
            if consentString == "0" {
                return true
            }
        }
        return false
    }
    open func buildDFPRequest(adUnit: String, targeting: [AnyHashable: Any]) -> DFPRequest {
        self.DFPAdView = DFPBannerView(adSize: self.dimension)
        self.DFPAdView?.delegate = self
        self.DFPAdView?.appEventDelegate = self
        self.DFPAdView?.enableManualImpressions = true
        self.DFPAdView?.adUnitID = adUnit
        self.DFPAdView?.rootViewController = self
        let DFPAdRequest = DFPRequest()
        // Add key-values
        var targetingModifiable = targeting
        targetingModifiable[self.adManagerKeyForGma] = self.adManagerValueForGma
        DFPAdRequest.customTargeting = targetingModifiable
        // Add location of initial ad requet
        DFPAdRequest.setLocationWithLatitude(self.customEventRequest.userLatitude,
                                             longitude: self.customEventRequest.userLongitude,
                                             accuracy: self.customEventRequest.userLocationAccuracyInMeters)
        return DFPAdRequest
    }
    open func loadDFPAd(_ requestDFPAd: DFPRequest) {
        SOMLogger.log(.developer, self.logBreadcrumbs, "Load ad via DFP...")
        self.DFPAdView?.load(requestDFPAd)
    }
    open func proceedWithOtherNetwork(_ errorCode: GADErrorCode, message: String) { // Skip ad network
        let userInfo = ["details": message]
        let appKeyError = NSError(domain: customEventErrorDomain, code: errorCode.rawValue, userInfo: userInfo)
        SOMLogger.log(.developer, self.logBreadcrumbs, "Proceed with other network, reason: %@", [message])
        self.delegate?.customEventBanner(self, didFailAd: appKeyError)
        return
    }
    open func parametersMissing(keys: [String]) -> Bool {
        for key in keys where self.extractedParameters[key] == nil {
            return true
        }
        return false
    }
    open func logParameters(keys: [String]) {
        for key in keys {
            if self.extractedParameters[key] == nil {
                SOMLogger.log(.developer, self.logBreadcrumbs, "%@ not set", [key])
            } else {
                SOMLogger.log(.developer, self.logBreadcrumbs, "%@=%@", [key, self.extractedParameters[key]!])
            }
        }
    }
}
extension SOMMediationAdapter: GADBannerViewDelegate, GADAppEventDelegate {
    // Tells the delegate that an ad request successfully received an ad. The delegate may want to add
    // the banner view to the view hierarchy if it hasn't been added yet.
    open func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        SOMLogger.log(.developer, self.logBreadcrumbs, "Callback adViewDidReceiveAd() triggered.")
        if let delayString = self.extractedParameters[self.parameterKeyForDelay] {
            if let delay = NumberFormatter().number(from: delayString) {
                self.delay = delay.doubleValue
            }
        }
        perform(#selector(self.callReceiveAd(_:)), with: bannerView, afterDelay: self.delay)
    }
    @objc open func callReceiveAd(_ bannerView: GADBannerView) {
        SOMLogger.log(.developer, self.logBreadcrumbs,
                      "CallReceiveAd() invoked after waiting %@ seconds for a fallback event.",
                      [self.delay.debugDescription])
        if !self.isFallbackAd {
            SOMLogger.log(.developer, self.logBreadcrumbs, "No fallback ad received.")
            self.DFPAdView.recordImpression()
            SOMLogger.log(.developer, self.logBreadcrumbs, "Impression for ad triggered.")
            delegate?.customEventBanner(self, didReceiveAd: bannerView)
        } else {
            SOMLogger.log(.developer, self.logBreadcrumbs, "Fallback ad received.")
            self.proceedWithOtherNetwork(GADErrorCode.noFill, message: "Fallback ad received")
        }
    }
    // Tells the delegate that an ad request failed. The failure is normally due to network
    // connectivity or ad availablility (i.e., no fill).
    open func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        SOMLogger.log(.developer, self.logBreadcrumbs,
                      "Callback adView() triggered with message: %@", [error.localizedDescription])
        delegate?.customEventBanner(self, didFailAd: error)
    }
    // Called when an ad view receives a fallback event.
    open func adView(_ bannerView: GADBannerView, didReceiveAppEvent name: String, withInfo info: String?) {
        SOMLogger.log(.developer, self.logBreadcrumbs,
                      "Callback adView() triggered with name=%@ and info=%@", [name, info!])
        if name.elementsEqual(self.fallbackValueForKeyName)
            && (info?.elementsEqual(self.fallbackValueForKeyInfo))! {
            self.isFallbackAd = true
        }
    }
    // Tells the delegate that a full screen view will be presented in response to the user clicking on
    // an ad. The delegate may want to pause animations and time sensitive interactions.
    open func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        SOMLogger.log(.developer, self.logBreadcrumbs, "Callback adViewWillPresentScreen() triggered.")
    }
    // Tells the delegate that the full screen view will be dismissed.
    open func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        SOMLogger.log(.developer, self.logBreadcrumbs, "Callback adViewWillDismissScreen() triggered.")
    }
    // Tells the delegate that the full screen view has been dismissed. The delegate should restart
    // anything paused while handling adViewWillPresentScreen:.
    open func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        SOMLogger.log(.developer, self.logBreadcrumbs, "Callback adViewDidDismissScreen() triggered.")
    }
    // Tells the delegate that the user click will open another app, backgrounding the current
    // application. The standard UIApplicationDelegate methods, like applicationDidEnterBackground:,
    // are called immediately before this method is called.
    open func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        SOMLogger.log(.developer, self.logBreadcrumbs, "Callback adViewWillLeaveApplication() triggered.")
        delegate?.customEventBannerWasClicked(self)
        delegate?.customEventBannerWillLeaveApplication(self)
    }
}
