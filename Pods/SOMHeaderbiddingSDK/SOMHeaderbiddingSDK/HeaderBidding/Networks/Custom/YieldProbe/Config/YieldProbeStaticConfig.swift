//
//  YieldProbeConfig.swift
//  SOMHeaderbiddingSDK
//
//  Created by Julian Brehm on 2018-09-06.
//  Copyright © 2018 SevenOne Media. All rights reserved.
//

/** This config is used by the YieldProbe network classes.
 It contains required and optional keys and values
 for requests and responses for YieldProbe and AdManager. */
internal struct YieldProbeStaticConfig {
    struct Request {
        static let useCookiesInRequest = false
        static let scheme = "https"
        static let host = "ad.yieldlab.net"
        static let pathWithSlotId = "/yp/%@"
    }
    struct RequestKey {
        static let latitude = "lat"
        static let longitude = "lon"
        static let idfa = "yl_rtb_ifa"
        static let json = "json"
        static let pvid = "pvid"
        static let connectionType = "yl_rtb_connectiontype"
        static let deviceType = "yl_rtb_devicetype"
        static let timestamp = "ts"
    }
    struct RequestValue {
        static let phone = "4"
        static let tablet = "5"
        static let json = "true"
        static let pvid = "true"
    }
    struct FallbackValue {
        static let prio = "14"
    }
    struct ResponseKey {
        static let pid = "pid"
        static let pvid = "pvid"
        static let prio = "prio"
        static let identifier = "id"
        static let advertiser = "advertiser"
        static let curl = "curl"
        static let format = "format"
        static let did = "did"
        static let price = "price"
    }
    static let requiredResponseKeys = [ResponseKey.pid,
                                       ResponseKey.pvid,
                                       ResponseKey.prio]
    static let optionalResponseKeys = [ResponseKey.identifier,
                                       ResponseKey.advertiser,
                                       ResponseKey.curl,
                                       ResponseKey.format,
                                       ResponseKey.did,
                                       ResponseKey.price]
    public struct AdManagerRequestKey {
        static let aid = "ylaid"
        static let pid = "ylpid"
        static let pvid = "ylpvid"
        static let ylb = "yl"
        static let pricePoint = "ylpb"
    }
}
