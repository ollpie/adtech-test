

#import <Foundation/Foundation.h>

@interface NuggAdPredictionConfig : NSObject

+(NuggAdPredictionConfig*) defaultConfig;

@property (copy, nonatomic) NSString* appId;
@property (copy, nonatomic) NSString* domain;
@property (copy, nonatomic) NSString* dataProviderId;
@property (copy, nonatomic) NSString* networkId;

- (NSDictionary *)asParams;

@end
