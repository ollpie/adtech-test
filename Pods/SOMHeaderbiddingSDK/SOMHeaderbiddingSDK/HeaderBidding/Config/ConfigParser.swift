//
//  ConfigParser.swift
//  SOMHeaderbiddingSDK
//
//  Created by Julian Brehm on 2018-09-04.
//  Copyright © 2018 SevenOne Media. All rights reserved.
//

import Foundation
import SOMCore

/** This class is needed because the SDK offers an option to initialize it with a Json string. */
internal class ConfigParser {
    // MARK: Private variables
    internal static var logBreadcrumbs: [String] =
        [String(describing: HeaderBiddingSDK.self), String(describing: ConfigParser.self)]
    // MARK: Public methods
    /** This function parses the Json string. */
    internal static func getNormalisedConfig(_ configString: String) -> [String: Any]? {
        if configString.isEmpty {
            SOMLogger.log(.force, logBreadcrumbs, "Config string is empty.")
            return nil
        }
        guard let rawConfigString = configString.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            SOMLogger.log(.force, logBreadcrumbs, "String is not a valid utf8 sequence.")
            return nil
        }
        guard let rawConfigObject = try? JSONSerialization.jsonObject(with: rawConfigString, options: []) else {
            SOMLogger.log(.force, logBreadcrumbs, "Configuration is no valid Json.")
            return nil
        }
        guard let config = self.getNormalisedConfig(rawConfigObject) else {
            SOMLogger.log(.force, logBreadcrumbs, "Could not normalize config: %@",
                          [String(describing: rawConfigObject)])
            return nil
        }
        return config
    }
    /** This function uses the comfig object to return a RemoteConfig instance. */
    internal static func getNormalisedConfig(_ rawConfigObject: Any) -> [String: Any]? {
        guard let config = rawConfigObject as? [String: Any] else {
            SOMLogger.log(.force, logBreadcrumbs, "Abort, Json structure for config is unknown.")
            return nil
        }
        return config // Success, each required config parameter was available in the parsed config
    }
}
