//
//  NuggAdPermission.m
//  nuggAdLib
//
//  Created by Benjamin Müller on 09.09.12.
//  Copyright (c) 2012 urbn. All rights reserved.
//

#import "NuggAdPermission.h"

#ifdef __IPHONE_6_0
#import <AdSupport/AdSupport.h>
#endif

@implementation NuggAdPermission

#pragma mark - SINGLETON

+ (NuggAdPermission *)sharedPermissions
{
    static dispatch_once_t pred;
    static NuggAdPermission *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[NuggAdPermission alloc] init];
    });
    
    return shared;
}

#pragma mark - PUBLIC
-(Boolean)readGlobalPermission{
    
    // ios 6 - check global ad tracking permission
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
        Boolean agreement_global = [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
        
        if (!agreement_global) {
            return FALSE;
        }
    }

    return true;
}

-(NSUUID*)adID{
    if (self.readGlobalPermission) {
        NSUUID* adid = [[ASIdentifierManager sharedManager] advertisingIdentifier];
        NSLog(@"AD ID: %@", [adid UUIDString]);
        
        return adid;
    }
    return nil;
}

-(Boolean)checkFirstCall{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"nuggad_prediction"]) return true;
    
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"nuggad_prediction"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return false;
}

@end

