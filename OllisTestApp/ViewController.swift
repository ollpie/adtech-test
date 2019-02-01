//
//  ViewController.swift
//  OllisTestApp
//
//  Created by Oliver Pieper on 12.12.18.
//  Copyright © 2018 Oliver Pieper. All rights reserved.
//

import UIKit
import SOMHeaderbiddingSDK
import SOMCore
import GoogleMobileAds

let wettercomURL = "https://ad.71i.de/global_js/AppConfig/Wettercom/1.20.0/iphone.json"
let showroom = "mobbanner"

class ViewController: UIViewController {
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBAction func reload(_ sender: Any) {
        spinner.isHidden = false
        spinner.startAnimating()
        HeaderBiddingSDK.shared.update()
        
        let banner = DFPBannerView(adSize: kGADAdSizeBanner)
        bannerView.addSubview(banner)
        banner.adUnitID = "/5731/DE_WETTERCOM.InAPP/DISPLAY_iPHONE.vorhersage"
        banner.rootViewController = self

        var targeting = [String: String]()
        targeting["pos"] = "1"
        targeting["vpos"] = "0"
        targeting["gma"] = "1"
        targeting["kw"] = "mediation"
        targeting["idf"] = "wetter"
        targeting["mob"] = "iphone"
        
        let headerBiddingTargeting = HeaderBiddingSDK.shared.getTargeting("banner")
        for (key, value) in headerBiddingTargeting {
            targeting[key] = value
        }
        
        let request = DFPRequest()
        request.customTargeting = targeting
        banner.load(request)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.isHidden = true
        initializeHeaderBiddingSDK()
    }
    
    func adViewDidReceiveAd(_ bannerView: DFPBannerView) {
        spinner.isHidden = true
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }

    func initializeHeaderBiddingSDK() {
        SOMLogger.displayAllLogs = true
        if !HeaderBiddingSDK.shared.isInitialized {
            SOMLogger.log("Fetch ad config and initialize SDK.")
            guard let url = URL(string: "https://ad.71i.de/global_js/AppConfig/Wettercom/1.20.0/iphone.json") else {
                SOMLogger.log("URL not created.")
                return
            }
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { (data, _, err) in
                guard let adConfigData = data else {
                    SOMLogger.log("Data is nil.")
                    return
                }
                // Extract the Header Bidding configuration from SOM ad config.
                guard let adConfigJson = try? JSONSerialization.jsonObject(with: adConfigData, options: []) else {
                    SOMLogger.log("Data could not be parsed.")
                    return
                }
                guard let adConfig = adConfigJson as? [String: Any] else {
                    SOMLogger.log("Json is not in the correct format.")
                    return
                }
                guard let displayAd = adConfig["displayAd"] as? [String: Any] else {
                    SOMLogger.log("Json does not contain displayAd node.")
                    return
                }
                guard let displayTarget = displayAd["target"] as? [String: Any] else {
                    SOMLogger.log("Json does not contain displayTarget node.")
                    return
                }
                //print(displayTarget)
                guard let bannerTarget = displayTarget["banner"] as? [Any] else {
                    SOMLogger.log("Json does not contain bannerTaget node.")
                    return
                }
                let a = bannerTarget[0]

                guard let headerBiddingConfig = adConfig["headerBidding"] as Any? else {
                    SOMLogger.log("Json does not contain header bidding node.")
                    return
                }

                // Initialize the SDK
                HeaderBiddingSDK.shared.initialize(headerBiddingConfig, nonPersonalisedAdsEnabled: false)
                HeaderBiddingSDK.shared.update()

                }.resume()
        }

    }

}

