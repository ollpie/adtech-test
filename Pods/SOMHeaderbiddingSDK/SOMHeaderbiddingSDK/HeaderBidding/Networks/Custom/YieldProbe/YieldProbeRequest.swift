//
//  SOMYieldProbeRequest.swift
//  SOMHeaderbiddingSDK
//
//  Created by Julian Brehm on 2018-08-10.
//  Copyright © 2018 SevenOne Media. All rights reserved.
//

import UIKit
import AdSupport
import SOMCore

/** This class can build and perform a request to the YieldProbe server to retrieve a bid. */
class YieldProbeRequest {
    // MARK: Private static variables
    private static var logBreadcrumbs: [String] =
        [String(describing: HeaderBiddingSDK.self), String(describing: YieldProbeRequest.self)]
    // MARK: Internal static interface functions
    /**
     Get bid from YieldLab server for defined ad slot.
     - Returns: (after completion) Extracted bid parameters.
     */
    internal static func requestBidFor(_ slot: NetworkSlot,
                                       completion: @escaping (_ data: [String: String]?) -> Void) {
        guard let url = yieldProbeUrlString(slot) else {
            completion(nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpShouldHandleCookies = YieldProbeStaticConfig.Request.useCookiesInRequest
        URLSession.shared.dataTask(with: request) { (data, _, _) in
            guard let data = data else {
                SOMLogger.log(.developer, self.logBreadcrumbs + [slot.name],
                              "Abort, no data received.")
                completion(nil)
                return
            }
            guard let bidDictionary = self.getBidDictionary(data, slot) else {
                SOMLogger.log(.developer, self.logBreadcrumbs + [slot.name], "Abort, received data is not valid.")
                completion(nil)
                return
            }
            guard let bidParameter = self.getBidParameter(bidDictionary, slot) else {
                SOMLogger.log(.developer, self.logBreadcrumbs + [slot.name], "Abort, required keys missing.")
                return
            }
            completion(bidParameter)
            return
            }.resume()
    }
    // MARK: Internal static methods
    /**
     - Parameter data: Json data received from a URLSession.shared.dataTask.
     - Returns: Dictionary containing bid information.
     */
    internal static func getBidDictionary(_ data: Data, _ slot: NetworkSlot) -> [String: Any]? {
        guard let string = String(bytes: data, encoding: .utf8) else {
            SOMLogger.log(.developer, self.logBreadcrumbs + [slot.name],
                          "Not able to create Json string from returned data.")
            return nil
        }
        SOMLogger.log(.developer, self.logBreadcrumbs, "Json string from YieldLab server: %@", [string])
        guard let jsonObject = string.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            SOMLogger.log(.developer, self.logBreadcrumbs + [slot.name], "String is not a valid utf8 sequence.")
            return nil
        }
        guard let dataDictionary = try? JSONSerialization.jsonObject(with: jsonObject, options: []) else {
            SOMLogger.log(.developer, self.logBreadcrumbs + [slot.name], "Json could not be parsed.")
            return nil
        }
        guard let test = dataDictionary as? [AnyObject] else {
            SOMLogger.log(.developer, self.logBreadcrumbs + [slot.name], "Json is not in the expected format.")
            return nil
        }
        if test.count < 1 {
            SOMLogger.log(.developer, self.logBreadcrumbs + [slot.name], "No data available in Json.")
            return nil
        }
        guard let bidData = test[0] as? [String: Any] else {
            SOMLogger.log(.developer, self.logBreadcrumbs + [slot.name], "Json doesn't contain a dictionary.")
            return nil
        }
        return bidData
    }
    /**
     - Parameter data: Bid data extracted with extractBidInformation().
     - Returns: Dictionary containing required and optional parameters with normalized values (Any->String).
     */
    internal static func getBidParameter(_ data: [String: Any], _ slot: NetworkSlot) -> [String: String]? {
        var requiredKeysAreNotAvailable = false // Use this to log each missing parameter in Json!
        var bid = [String: String]()
        for key in YieldProbeStaticConfig.requiredResponseKeys {
            if data[key] == nil {
                SOMLogger.log(.developer, self.logBreadcrumbs + [slot.name], "Parameter >%@< missing in Json.", [key])
                if key == YieldProbeStaticConfig.ResponseKey.prio {
                    bid[key] = YieldProbeStaticConfig.FallbackValue.prio
                    SOMLogger.log(.developer, self.logBreadcrumbs + [slot.name], "Default value >%@< set for key >%@<.",
                                  [YieldProbeStaticConfig.FallbackValue.prio, key])
                } else {
                    requiredKeysAreNotAvailable = true
                }
            } else {
                bid[key] = String(describing: data[key]!)
            }
        }
        if requiredKeysAreNotAvailable {
            return nil
        }
        for key in YieldProbeStaticConfig.optionalResponseKeys where data[key] != nil {
            bid[key] = String(describing: data[key]!)
        }
        return bid
    }
    /**
     Builds a URL instance used to request a bid from YieldLab for a specific slot containing targeting parameter.
     - Returns: YieldLab URL for bid request.
     */
    internal static func yieldProbeUrlString(_ slot: NetworkSlot) -> URL? {
        var components = URLComponents()
        components.scheme = YieldProbeStaticConfig.Request.scheme
        components.host = YieldProbeStaticConfig.Request.host
        guard let identifier = slot.identifier else {
            SOMLogger.log(.developerError, self.logBreadcrumbs, "Slot identifier missing.", [slot.name])
            return nil
        }
        components.path = String(format: YieldProbeStaticConfig.Request.pathWithSlotId, identifier)
        var queryItems = [URLQueryItem]()
        if !SOMShared.nonPersonalisedAdsEnabled {
            if let currentLocation = SOMLocationManager.shared.currentLocation {
                queryItems.append(URLQueryItem(name: YieldProbeStaticConfig.RequestKey.latitude,
                                               value: String(describing: currentLocation.coordinate.latitude)))
                queryItems.append(URLQueryItem(name: YieldProbeStaticConfig.RequestKey.longitude,
                                               value: String(describing: currentLocation.coordinate.longitude)))
            }
            // Only pass if IDFA is enabled
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                queryItems.append(URLQueryItem(name: YieldProbeStaticConfig.RequestKey.idfa,
                                               value: ASIdentifierManager.shared().advertisingIdentifier.uuidString))
            }
        }
        queryItems.append(URLQueryItem(name: YieldProbeStaticConfig.RequestKey.json,
                                       value: YieldProbeStaticConfig.RequestValue.json))
        queryItems.append(URLQueryItem(name: YieldProbeStaticConfig.RequestKey.pvid,
                                       value: YieldProbeStaticConfig.RequestValue.pvid))
        queryItems.append(URLQueryItem(name: YieldProbeStaticConfig.RequestKey.connectionType,
                                       value: String(describing: SOMConnectivityManager.shared.connectionType)))
        let deviceType = UIDevice.current.userInterfaceIdiom == .pad
            ? YieldProbeStaticConfig.RequestValue.tablet : YieldProbeStaticConfig.RequestValue.phone
        queryItems.append(URLQueryItem(name: YieldProbeStaticConfig.RequestKey.deviceType, value: deviceType))
        let timestamp = String(describing: Int(NSDate().timeIntervalSince1970))
        queryItems.append(URLQueryItem(name: YieldProbeStaticConfig.RequestKey.timestamp, value: timestamp))
        components.queryItems = queryItems
        guard let url = components.url else {
            SOMLogger.log(.request, self.logBreadcrumbs + [slot.name], "Could not build URL.")
            return nil
        }
        SOMLogger.log(.request, self.logBreadcrumbs + [slot.name],
                      "Request URL: %@", [components.url!.absoluteString])
        return url
    }
}
