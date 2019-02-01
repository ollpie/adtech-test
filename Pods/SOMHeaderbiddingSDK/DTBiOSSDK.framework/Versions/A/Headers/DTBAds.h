//
//  DTBAds.h
//  DTBiOSSDK
//
//  Created by Singh, Prashant Bhushan on 1/30/15.
//  Copyright (c) 2015 amazon.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTBLog.h"

typedef enum
{
    // set as default use MoPub, then DFP
    AUTO_DETECT_MRAID,
    // set mraid version based on DFP
    DFP_MRAID,
    // set mraid version based on MOPUB
    MOPUB_MRAID,
    // ignore mraid version
    NONE_MRAID,
    // use applicatio set MRAID version
    CUSTOM_MRAID
} DTBMRAIDPolicy;

@interface DTBAds : NSObject

@property (nonatomic) BOOL useSecureConnection;
@property (nonatomic) BOOL testMode;
@property (nonatomic) BOOL useGeoLocation;
@property (nonatomic) DTBMRAIDPolicy mraidPolicy;
@property (nonatomic) NSArray<NSString *> *  _Nullable mraidCustomVersions;

+ (DTBAds * _Nonnull)sharedInstance;

// Set the applicationId provided by the Amazon Appstore.
- (void)setAppKey:(NSString * _Nonnull)appKey;

// Retrieves the appKey, if already stored, otherwise will throw an exception
- (NSString * _Nullable)appKey;

- (void)setLogLevel: (DTBLogLevel)logLevel;

- (BOOL)handleURL: (NSURL *  _Nonnull)url;

+ (NSString * _Nonnull)version;

@end
