#import "NuggAdPredictionConfig.h"

#define PLIST_CONFIG_FILE_NAME @"nuggadconfig"
#define PLIST_CONFIG_DOMAIN_KEY @"nugg_domain"
#define PLIST_CONFIG_NUGGN_KEY @"nugg_networkid"
#define PLIST_CONFIG_NUGGSID_KEY @"nugg_app_id"
#define PLIST_CONFIG_RID_KEY @"nuggrid"
#define PLIST_CONFIG_NUGG_DPID @"nugg_data_provider_id"


@implementation NuggAdPredictionConfig

+(NuggAdPredictionConfig*) defaultConfig {
    NuggAdPredictionConfig *config = [[NuggAdPredictionConfig alloc] init];
    
    NSString *plistPath = [[NSBundle bundleForClass:[self class]] pathForResource:PLIST_CONFIG_FILE_NAME ofType:@"plist"];
    
    
    if ( ! [[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        NSLog(@"#### NUGG AD ## Config file not found. Please make sure a file named '%@' exists in your apps document directory.",PLIST_CONFIG_FILE_NAME);
    } else {
        NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        
        if (dict)
        {
            // set nugg_domain
            NSString *nugg_domain = [[dict valueForKey:PLIST_CONFIG_DOMAIN_KEY] copy];
            NSAssert(nugg_domain, @"#### NUGG AD ## Configuration is missing: Make sure to specify values for the following key(s) '%@'",PLIST_CONFIG_DOMAIN_KEY);

            [config setDomain:nugg_domain];
            
            // set nugg_networkid
            NSString *nugg_networkid = [[dict valueForKey:PLIST_CONFIG_NUGGN_KEY] copy];
            NSAssert(nugg_networkid, @"#### NUGG AD ## Configuration is missing: Make sure to specify values for the following key(s) '%@'",PLIST_CONFIG_NUGGN_KEY);
            
            [config setNetworkId:nugg_networkid];
            
            // set nugg_app_id
            NSString *nugg_app_id = [[dict valueForKey:PLIST_CONFIG_NUGGSID_KEY] copy];
            NSAssert(nugg_app_id, @"#### NUGG AD ## Configuration is missing: Make sure to specify values for the following key(s) '%@'",PLIST_CONFIG_NUGGSID_KEY);
            [config setAppId:nugg_app_id];
            
            // dpid for ut call
            if([dict valueForKey:PLIST_CONFIG_NUGG_DPID]) {
                NSString *nugg_data_provider = [[dict valueForKey:PLIST_CONFIG_NUGG_DPID] copy];
                [config setDataProviderId:nugg_data_provider];
            }
        } else {
            NSLog(@"#### NUGG AD ## Configuration failed ####");
        }
    }
    
    return config;
}

- (NSDictionary *)asParams {
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    if(self.networkId) params[@"nuggn"] = self.networkId;
    if(self.appId) params[@"nuggsid"] = self.appId;
    
    return params;
        
}

@end
