//
//  SOMLogger.swift
//  SOMCore
//
//  Created by Julian Brehm on 2018-07-24.
//  Copyright © 2018 SevenOne Media. All rights reserved.
//

import Foundation

/** Public logger used by all SOM SDKs. */
public final class SOMLogger {
    // MARK: Public variables
    public static var enabledLogTags: [LogTag] = []
    // MARK: Public enums
    public enum LogTag {
        case debug // Normal debug logs to check if everything is running e.g. initialization, ids etc.
        case developer // All logs that are mainly used while developing SDK e.g. config parsing
        case developerError // Will be used for errors that result from wrong SDK usage
        case request // All request information and urls
        case response // All response objects
        case force // Log message is forced
    }
    // MARK: Public variables
    public static var displayAllLogs: Bool = false
    // MARK: Public functions
    public static func enableLogTags(_ levels: [LogTag]) { // Log levels to be displayed
        self.enabledLogTags = levels
    }
    // No log tags
    public static func log(_ string: String) {
        self.log([.debug], [], string, [])
    }
    public static func log(_ string: String, _ values: [String?]) {
        self.log([.debug], [], string, values)
    }
    public static func log(_ breadcrumbs: [String?], _ string: String) {
        self.log([.debug], breadcrumbs, string, [])
    }
    public static func log(_ breadcrumbs: [String?], _ string: String, _ values: [String?]) {
        self.log([.debug], breadcrumbs, string, values)
    }
    // One log tag
    public static func log(_ logTag: LogTag, _ string: String) {
        self.log([logTag], [], string, [])
    }
    public static func log(_ logTag: LogTag, _ string: String, _ values: [String?]) {
        self.log([logTag], [], string, values)
    }
    public static func log(_ logTag: LogTag, _ breadcrumbs: [String?], _ string: String) {
        self.log([logTag], breadcrumbs, string, [])
    }
    public static func log(_ logTag: LogTag, _ breadcrumbs: [String?], _ string: String, _ values: [String?]) {
        self.log([logTag], breadcrumbs, string, values)
    }
    // Multible log tags
    public static func log(_ logTags: [LogTag], _ string: String) {
        self.log(logTags, [], string, [])
    }
    public static func log(_ logTags: [LogTag], _ string: String, _ values: [String?]) {
        self.log(logTags, [], string, values)
    }
    public static func log(_ logTags: [LogTag], _ breadcrumbs: [String?], _ string: String) {
        self.log(logTags, breadcrumbs, string, [])
    }
    public static func log(_ logTags: [LogTag], _ breadcrumbs: [String?], _ string: String, _ values: [String?]) {
        let intersection = self.enabledLogTags.filter(logTags.contains)
        if displayAllLogs
        || logTags.contains(LogTag.force)
        || intersection.count > 0 {
            NSLog("%@: %@",
                  self.guardValues(values: breadcrumbs).joined(separator: " "),
                  String(format: string, arguments: self.guardValues(values: values)))
        }
    }
    public static func getLogTagsFromString(_ tagsString: [String]) -> [LogTag] {
        var logTags: [LogTag] = []
        for tagString in tagsString {
            let lagStringLow = tagString.lowercased()
            switch lagStringLow {
            case "debug".lowercased():
                logTags.append(.debug)
            case "developer".lowercased():
                logTags.append(.developer)
            case "developerError".lowercased():
                logTags.append(.developerError)
            case "request".lowercased():
                logTags.append(.request)
            case "response".lowercased():
                logTags.append(.response)
            default:
                continue
            }
        }
        return logTags
    }
    internal static func guardValues(values: [String?]) -> [String] {
        var valuesNormalized = [String]()
        for value in values {
            guard let value = value else {
                valuesNormalized.append("Nil")
                continue
            }
            valuesNormalized.append(value)
        }
        return valuesNormalized
    }
}
