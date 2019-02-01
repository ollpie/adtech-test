//
//  NuggAdService.h
//  nuggAdLib
//
//  Created by Benjamin Müller on 09.09.12.
//  Copyright (c) 2012 urbn. All rights reserved.
//

/*!
 @header NuggAdPermission
 @internal
 */

#import <Foundation/Foundation.h>
#import "NuggAdPrediction.h"
#import "NuggAdPredictionConfig.h"


#define SERVICE_TIMEOUT 0.6

typedef enum : NSUInteger {
    NUGG_AD_SERVICE_CALL_RC,
    NUGG_AD_SERVICE_CALL_CI,
    NUGG_AD_SERVICE_CALL_UT,
    NUGG_AD_SERVICE_CALL_FC
} NUGG_AD_SERVICE_CALL_TYPE;

@interface NuggAdService : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic,copy) NSString* nuggDomain;
@property (nonatomic,copy) NSString* nuggN;
@property (nonatomic,copy) NSString* nuggSid;
@property (copy) NSString* nuggDPID;

@property (nonatomic,strong) NuggAdPrediction* nuggAdPredictionObj;

+(NuggAdService *)sharedService;

/**
 *  RC call
 *
 *  @param referrer             any referrer
 *  @param permission           permissions
 *  @param adid        advertisement identifier (if permission true)
 */
-(void)nuggadRC:(NSString*)referrer andPermission:(Boolean)permission andAdID:(NSUUID*)adid;
-(void)nuggadRC:(NSString *)referrer andPermission:(Boolean)permission andAdID:(NSUUID*)adid andConfig: (NuggAdPredictionConfig*) config;

/**
 *  calls the CI endpoint. network_id is taken from the properties (plist)
 *
 *  @param campaign_id a campaign id
 *  @param format_id   a format id
 *  @param permission  permissions
 *  @param adid        advertisement identifier (if permission true)
 */
-(void)nuggadCI:(NSString*)campaign_id andFormat:(NSString*)format_id andPermission:(Boolean)permission andAdID:(NSUUID*)adid;

/**
 *  calls the UT endpoint.
 *
 *  @param dpid         dataprovider id
 *  @param productslist list of NuggAdUTProduct
 *  @param permission   permission
 *  @param adid        advertisement identifier (if permission true)
 */
-(void)nuggadUT:(NSString*)dpid andProductsList:(NSArray*)productslist andPermission:(Boolean)permission andAdID:(NSUUID*)adid;

/**
 *  calls the the fc endpoint to set fc counter.
 *
 *  @param canceled   whether survey was canceled
 *  @param permission permission
 *  @param adid       advertisement identifier (if permission true)
 */
-(void)nuggadFC:(Boolean)completed andPermission:(Boolean)permission andAdID:(NSUUID*)adid;
@end
