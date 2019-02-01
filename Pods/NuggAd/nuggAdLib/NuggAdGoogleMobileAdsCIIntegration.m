//
//  NuggAdGoogleMobileAdsCIIntegration.m
//  nuggAdLib
//
//  Created by Benjamin Müller on 17.06.14.
//  Copyright (c) 2014 urbn. All rights reserved.
//

#import "NuggAdGoogleMobileAdsCIIntegration.h"
#import "NSURL+Parameters.h"

@implementation NuggAdGoogleMobileAdsCIIntegration

#pragma mark - INIT

+(NuggAdGoogleMobileAdsCIIntegration *)sharedCIIntegration{
    static dispatch_once_t onceToken;
    static NuggAdGoogleMobileAdsCIIntegration* __instance;
    dispatch_once(&onceToken, ^{
        __instance = [[NuggAdGoogleMobileAdsCIIntegration alloc] init];
    });
    
    return __instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - PUBLIC
-(void)extractCIFromAdView:(GADBannerView *)bannerView andCallNuggad:(NuggAdPrediction *)predictionObj{
    
    NSParameterAssert(bannerView);
    NSParameterAssert(predictionObj);
    
    UIWebView* wv = ((UIView*)bannerView).subviews.firstObject;
    
    // inject JS to find CI pixel with src starting with 'http://ci.nuggad.net'
    NSString* ciURL = [wv stringByEvaluatingJavaScriptFromString:@"function nugg_ci(){a = document.getElementsByTagName('img'); out = []; for(i=0; i<a.length; i++){ var src = a[i].getAttribute('src'); out.push(src); if(src.substring(0,20) == 'http://ci.nuggad.net'){ return src;}  } return out.toString(); }; nugg_ci();"];
    
    NSURL* url = [NSURL URLWithString:ciURL];
    
    NSString* campid = [url parameterForKey:@"campid"];
    NSString* ad_format_id = [url parameterForKey:@"ad_format_id"];
    
    
    // log
    NSLog(@"campid: %@, ad_format_id: %@",campid,ad_format_id);
    
    if([predictionObj.delegate respondsToSelector:@selector(nuggAdShouldLogRequests:)] &&
       [predictionObj.delegate nuggAdShouldLogRequests:predictionObj]){
        if (!campid || !ad_format_id)
            NSLog(@"no valid ci URL found");
        else
            NSLog(@"CI request with campid:'%@' and adFormat:'%@'",campid,ad_format_id);
    }
    if (!campid || !ad_format_id) return;
    
    [predictionObj nuggadCI:campid andFormat:ad_format_id];
}

@end
