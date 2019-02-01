//
//  SOIAdapterSmaato.swift
//  TestAppiOS
//
//  Created by brehmjuNL on 2018-06-14.
//  Copyright © 2018 SevenOne Media. All rights reserved.
//
import Foundation
import GoogleMobileAds
import iSoma
import SOMCore

@objc public class SOMAdapterSmaato: SOMMediationAdapter {
    public var SOMABannerAd: SOMAAdView?
    let parameterKeyForPublisher = "publisher"
    let parameterKeyForAdSpace = "adSpace"
    override public func performAdRequest() {
        self.buildSOMARequest()
        self.loadSOMAAd()
    }
    override public func setLogTag(_ logSize: GADAdSize) {
        self.width = Int(self.size.size.width)
        self.height = Int(self.size.size.height)
        self.logBreadcrumbs = [String(describing: SOMAdapterSmaato.self),
                               String(describing: self.width),
                               String(describing: self.height)]
    }
    override public func setKeys() {
        self.requiredKeys = [self.parameterKeyForPublisher,
                             self.parameterKeyForAdSpace]
        self.optionalKeys = []
    }
    func buildSOMARequest() {
        guard let publisherIdString = self.extractedParameters[self.parameterKeyForPublisher] else {
            self.proceedWithOtherNetwork(GADErrorCode.internalError, message: "Publisher id is undefined.")
            return
        }
        guard let publisherId = NumberFormatter().number(from: publisherIdString) else {
            self.proceedWithOtherNetwork(GADErrorCode.internalError, message: "Publisher id is no number.")
            return
        }
        guard let adSpaceIdString = self.extractedParameters[self.parameterKeyForAdSpace] else {
            self.proceedWithOtherNetwork(GADErrorCode.internalError, message: "Ad space id is undefined.")
            return
        }
        guard let adSpaceId = NumberFormatter().number(from: adSpaceIdString) else {
            self.proceedWithOtherNetwork(GADErrorCode.internalError, message: "Ad space id is no number")
            return
        }
        var rect = CGRect()
        rect.size = CGSizeFromGADAdSize(self.size)
        SOMABannerAd = SOMAAdView()
        SOMABannerAd?.adSettings.publisherId = publisherId.intValue
        SOMABannerAd?.adSettings.adSpaceId = adSpaceId.intValue
        SOMABannerAd?.adSettings.type = SOMAAdType.all
        SOMABannerAd?.adSettings.httpsOnly = true
        SOMABannerAd?.adSettings.dimension = self.mapDimensionDFPToSOMA()
        SOMABannerAd?.adSettings.isAutoReloadEnabled = false
        SOMABannerAd?.delegate = self
        SOMABannerAd?.frame = rect
        self.view = SOMABannerAd // Add banner to view hierarchy
    }
    func loadSOMAAd() {
        SOMLogger.log(.developer, self.logBreadcrumbs, "Load SOMA Ad...")
        SOMABannerAd?.load()
    }
    // Map DFP Ad size to SOMA Ad size
    func mapDimensionDFPToSOMA() -> SOMAAdDimension {
        switch self.dimension.size {
        case kGADAdSizeBanner.size:
            return SOMAAdDimension.default
        case kGADAdSizeLeaderboard.size:
            return SOMAAdDimension.leader
        case kGADAdSizeMediumRectangle.size:
            return SOMAAdDimension.medRect
        default:
            return SOMAAdDimension.default
        }
    }
}
extension SOMAdapterSmaato: SOMAAdViewDelegate {
    /*
     somaRootViewController:
     @brief Return a UIViewController instance that can present another view controller modally.
     @warning  Not implementing this method returning appropriate view controller might result in unusual behavior
     @attention If it is not implemented or return nil, banner will try to find a usable UIViewController
                but which may not work always depending the view hierarchy.
     */
    public func somaRootViewController() -> UIViewController {
        SOMLogger.log(.developer, self.logBreadcrumbs, "Callback somaRootViewController() triggered.")
        return self
    }
    public func somaAdViewWillLoadAd(_ adview: SOMAAdView) {
        SOMLogger.log(.developer, self.logBreadcrumbs, "Callback somaAdViewWillLoadAd() triggered.")
    }
    public func somaAdViewDidLoadAd(_ adview: SOMAAdView) {
        SOMLogger.log(.developer, self.logBreadcrumbs, "Callback somaAdViewDidLoadAd() triggered.")
        self.delegate?.customEventBanner(self, didReceiveAd: adview)
    }
    public func somaAdView(_ banner: SOMAAdView, didFailToReceiveAdWithError error: Error) {
        SOMLogger.log(.developer, self.logBreadcrumbs,
                      "Callback somaAdView() triggered with message: %@", [error.localizedDescription])
        self.delegate?.customEventBanner(self, didFailAd: error)
    }
    public func somaAdViewDidClick(_ adview: SOMAAdView) {
        SOMLogger.log(.developer, self.logBreadcrumbs, "Callback somaAdViewDidClick() triggered.")
    }
    public func somaAdViewWillEnterFullscreen(_ adview: SOMAAdView) {
        SOMLogger.log(.developer, self.logBreadcrumbs, "Callback somaAdViewWillEnterFullscreen() triggered.")
    }
    public func somaAdViewDidEnterFullscreen(_ adview: SOMAAdView) {
        SOMLogger.log(.developer, self.logBreadcrumbs, "Callback somaAdViewDidEnterFullscreen() triggered.")
        self.delegate?.customEventBannerWasClicked(self)
        self.delegate?.customEventBannerWillLeaveApplication(self)
    }
    public func somaAdViewWillExitFullscreen(_ adview: SOMAAdView) {
        SOMLogger.log(.developer, self.logBreadcrumbs, "Callback somaAdViewWillExitFullscreen() triggered.")
    }
    public func somaAdViewDidExitFullscreen(_ adview: SOMAAdView) {
        SOMLogger.log(.developer, self.logBreadcrumbs, "Callback somaAdViewDidExitFullscreen() triggered.")
        self.delegate?.customEventBanner(self, didReceiveAd: adview)
    }
    public func somaAdViewApplicationWillGoBackground(_ adview: SOMAAdView) {
        SOMLogger.log(.developer, self.logBreadcrumbs, "Callback somaAdViewApplicationWillGoBackground() triggered.")
    }
    public func somaAdViewApplicationDidBecomeActive(_ adview: SOMAAdView) {
        SOMLogger.log(.developer, self.logBreadcrumbs, "Callback somaAdViewApplicationDidBecomeActive() triggered.")
    }
    public func somaAdViewWillLeaveApplication(fromAd adview: SOMAAdView) {
        SOMLogger.log(.developer, self.logBreadcrumbs, "Callback somaAdViewWillLeaveApplication() triggered.")
    }
}
