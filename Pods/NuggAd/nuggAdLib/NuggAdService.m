//
//  NuggAdService.m
//  nuggAdLib
//
//  Created by Benjamin Müller on 09.09.12.
//  Copyright (c) 2012 urbn. All rights reserved.
//

#import "NuggAdService.h"
#import "NuggAdPermission.h"
#import "NuggAdUTProduct.h"
#import <sys/utsname.h>

#define NUGG_AD_COOKIE_DOMAIN           @".nuggad.net"
#define NUGG_AD_PERMISSION_COOKIE_NAME  @"nuggstop"
#define NUGG_AD_CALL_RESPONSE_SURVEY    @"url"

@implementation NuggAdService{
    NSMutableDictionary* _connections;
    NSOperationQueue* _queue;
}

#pragma mark - SINGLETON

+ (NuggAdService *)sharedService
{
    static dispatch_once_t pred;
    static NuggAdService *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[NuggAdService alloc] init];
    });
    
    return shared;
}

#pragma mark - INIT

-(id)init{
    if ((self = [super init])) {
        _connections = [NSMutableDictionary dictionary];
        _queue = [[NSOperationQueue alloc] init];
    }
    
    return self;
}


#pragma mark - PUBLIC
-(void)nuggadCall:(NSString*)url withParams:(NSDictionary*)params withPermission:(BOOL)permission callType:(NUGG_AD_SERVICE_CALL_TYPE)call_type{
    
    NSAssert(_nuggAdPredictionObj, @"An prediction must be set before calling any service");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
       
        NSDate *startPrepareRequest = [NSDate date];
        
        NSString* sysInfo = [NSString stringWithFormat:@"%@", [[UIDevice currentDevice] systemVersion]];
        
        // setup basic request
        NSString *urlString = [url copy];
        NSString *toc = @"";
        
        NSMutableArray* paramsList = [NSMutableArray array];
        for (NSString* key in [params allKeys]) {
            [paramsList addObject:[NSString stringWithFormat:@"%@=%@",key,params[key]]];
            
            if ([key isEqual:@"tok"]) {
                toc = params[key];
            }
        }
        
        urlString = [urlString stringByAppendingFormat:@"?%@",[paramsList componentsJoinedByString:@"&"]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                           timeoutInterval:SERVICE_TIMEOUT];
        
        //set headers
        //cookie
        
        NSMutableArray* cookieArray;
        
        // permission cookie
        NSDictionary *permissionCookieProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                                    NUGG_AD_COOKIE_DOMAIN, NSHTTPCookieDomain,
                                                    @"/", NSHTTPCookiePath,
                                                    @"nuggstopp", NSHTTPCookieName,
                                                    (!permission ? @"true" : @"false"), NSHTTPCookieValue,
                                                    nil];
        
        NSHTTPCookie *permissionCookie = [NSHTTPCookie cookieWithProperties:permissionCookieProperties];
        
        cookieArray = [NSMutableArray arrayWithObject:permissionCookie];
        
        NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookieArray];
        [request setAllHTTPHeaderFields:headers];
        
        // other header fields
        [request setValue:sysInfo forHTTPHeaderField:@"User-Agent"];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [request setValue:_nuggAdPredictionObj.currentVersion forHTTPHeaderField:@"nuggad-ios-sdk-version"];
        NSString* deviceName = machineName();
        [request setValue:deviceName forHTTPHeaderField:@"Device"];
        
        
        // Logging
        if (_nuggAdPredictionObj && _nuggAdPredictionObj.delegate &&
            [_nuggAdPredictionObj.delegate respondsToSelector:@selector(nuggAdShouldLogRequests:)] &&
            [_nuggAdPredictionObj.delegate nuggAdShouldLogRequests:_nuggAdPredictionObj]) {
            
            NSLog(@"### NUGG AD # Request # url: %@ # headers: %@",request.URL,[request allHTTPHeaderFields]);
        }
        
        NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self
                                                              startImmediately:NO];
        
        [_connections setObject:@{@"permission": @(permission), @"call_type": @(call_type), @"tok": toc}
                         forKey:@(connection.hash)];
        
        [connection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                              forMode:NSDefaultRunLoopMode];
        [connection start];
        
        // Logging
        if (_nuggAdPredictionObj && _nuggAdPredictionObj.delegate &&
            [_nuggAdPredictionObj.delegate respondsToSelector:@selector(nuggAd:required:toProcess:)] ) {
            
            NSDate *methodFinish = [NSDate date];
            NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:startPrepareRequest];
            
            [_nuggAdPredictionObj.delegate nuggAd:_nuggAdPredictionObj required:executionTime toProcess:@"2nd phase request preparation"];
        }
        
    });

}
#pragma mark - CONNECTION DELEGATE
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    // read request info and delete connection
    NUGG_AD_SERVICE_CALL_TYPE call_type = [_connections[@(connection.hash)][@"call_type"] intValue];
    [_connections removeObjectForKey:@(connection.hash)];
    
    // inform delegate about connection error
    if (call_type == NUGG_AD_SERVICE_CALL_RC) {
        [_nuggAdPredictionObj.delegate nuggAd:_nuggAdPredictionObj responseError:error];
    }
    
    if (call_type == NUGG_AD_SERVICE_CALL_CI &&
        [_nuggAdPredictionObj.delegate respondsToSelector:@selector(nuggAdCICallError:)]) {
        [_nuggAdPredictionObj.delegate nuggAdCICallError:_nuggAdPredictionObj];
    }
    
    if (call_type == NUGG_AD_SERVICE_CALL_UT &&
        [_nuggAdPredictionObj.delegate respondsToSelector:@selector(nuggAdUTCallError:)]) {
        [_nuggAdPredictionObj.delegate nuggAdUTCallError:_nuggAdPredictionObj];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    // for 204 didReceiveData will not be called - so we have to handle this here.
    
    if ([(NSHTTPURLResponse*)response statusCode] == 204) {
        
        // read request info and delete connection
        BOOL permission = [_connections[@(connection.hash)][@"permission"] boolValue];
        [_connections removeObjectForKey:@(connection.hash)];
        
        // if permission denied - inform delegate
        if (!permission) {
            [_nuggAdPredictionObj.delegate nuggAd:_nuggAdPredictionObj
                         responsePermissionDenied:![[NuggAdPermission sharedPermissions] readGlobalPermission]];
            
            return;
        }
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    NSDate *start = [NSDate date];
    
    // read request info and delete connection
    NUGG_AD_SERVICE_CALL_TYPE call_type = [_connections[@(connection.hash)][@"call_type"] intValue];
    BOOL permission = [_connections[@(connection.hash)][@"permission"] boolValue];
    NSString* toc = _connections[@(connection.hash)][@"tok"];
    [_connections removeObjectForKey:@(connection.hash)];
    
    // if permission denied - inform delegate
    if (!permission) {
        
        [_nuggAdPredictionObj.delegate nuggAd:_nuggAdPredictionObj
                     responsePermissionDenied:![[NuggAdPermission sharedPermissions] readGlobalPermission]];
        
        return;
    }
    
    // is this a ci call ?
    if (call_type == NUGG_AD_SERVICE_CALL_CI) {
        if ([_nuggAdPredictionObj.delegate respondsToSelector:@selector(nuggAdCICallSuccess:)]) {
            [_nuggAdPredictionObj.delegate nuggAdCICallSuccess:_nuggAdPredictionObj];
        }
        
        return;
    }
    
    // is this a UT call ?
    if (call_type == NUGG_AD_SERVICE_CALL_UT &&
        [_nuggAdPredictionObj.delegate respondsToSelector:@selector(nuggAdUTCallSuccess:)]) {
        
        [_nuggAdPredictionObj.delegate nuggAdUTCallSuccess:_nuggAdPredictionObj];
        
        return;
    }
    
    // is this a FC call ?
    if (call_type == NUGG_AD_SERVICE_CALL_FC) {
        // we don't need to inform delegate here.
        
        return;
    }

    NSString* print = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"response: %@",print);
    
    // survey
    NSError *e = nil;
    NSMutableDictionary* serializedResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
    
    if (!serializedResponse)
    {
        //NSLog(@"Serialization error: %@",e);
        NSMutableDictionary *customUserInfo = nil;
        if(e.userInfo)
        {
            customUserInfo = [e.userInfo mutableCopy];
            [customUserInfo setValue:@"Most likely due to wrong credentials." forKey:@"libnuggAdLib"];
        }
        
        NSError *er = [[NSError alloc] initWithDomain:e.domain code:e.code userInfo:customUserInfo];
        [_nuggAdPredictionObj.delegate nuggAd:_nuggAdPredictionObj responseError:er];
        
        return;
    }
    else if (_nuggAdPredictionObj && _nuggAdPredictionObj.delegate &&
             [_nuggAdPredictionObj.delegate respondsToSelector:@selector(nuggAdShouldLogRequests:)] &&
             [_nuggAdPredictionObj.delegate nuggAdShouldLogRequests:_nuggAdPredictionObj])
    {
        NSLog(@"### response: %@",serializedResponse);
    }
    
    NSString* surveyURLs = [serializedResponse objectForKey:NUGG_AD_CALL_RESPONSE_SURVEY];
    
    // if we get back an URL
    if (surveyURLs &&
        ![surveyURLs isKindOfClass:[NSNull class]] &&
        ![surveyURLs isEqualToString:@""]) {

        surveyURLs = [surveyURLs stringByAppendingFormat:@"&tok=%@",toc];
        
        NSURL* surveyURL = [NSURL URLWithString:surveyURLs];
        
        [_nuggAdPredictionObj.delegate nuggAd:_nuggAdPredictionObj showSurveyWithURL:surveyURL];
    }
    
    // remove survey URL from response body
    [serializedResponse removeObjectForKey:NUGG_AD_CALL_RESPONSE_SURVEY];
    
    // inform delegate about success and transfer response
    [_nuggAdPredictionObj.delegate nuggAd:_nuggAdPredictionObj
                          responseSuccess:serializedResponse];
    
    // Logging
    if (_nuggAdPredictionObj && _nuggAdPredictionObj.delegate &&
        [_nuggAdPredictionObj.delegate respondsToSelector:@selector(nuggAd:required:toProcess:)] ) {
        
        NSDate *methodFinish = [NSDate date];
        NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:start];
        
        [_nuggAdPredictionObj.delegate nuggAd:_nuggAdPredictionObj required:executionTime toProcess:@"rc response processing"];
    }
    
}

#pragma mark - PUBLIC
-(void)nuggadRC:(NSString *)referrer andPermission:(Boolean)permission andAdID:(NSUUID*)adid{
    NuggAdPredictionConfig *config = [NuggAdPredictionConfig defaultConfig];
    
    [self nuggadRC:referrer andPermission:permission andAdID:adid  andConfig:config];
}

-(void)nuggadRC:(NSString *)referrer andPermission:(Boolean)permission andAdID:(NSUUID*)adid andConfig: (NuggAdPredictionConfig*) config {

    NSMutableDictionary *params = [[config asParams] mutableCopy];
    
    if(referrer) {
        params[@"nuggtg"] = referrer;
    }
    
    if(_nuggAdPredictionObj.nuggRid) {
        params[@"nuggrid"] = _nuggAdPredictionObj.nuggRid;
    }
    
    if(permission) {
        params[@"tok"] = [adid UUIDString];
    }
    
    [self nuggadCall:[_nuggDomain stringByAppendingString:@"/rc"]
          withParams:params
      withPermission:permission
            callType:NUGG_AD_SERVICE_CALL_RC];
}


-(void)nuggadCI:(NSString *)campaign_id andFormat:(NSString *)format_id andPermission:(Boolean)permission andAdID:(NSUUID*)adid{
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    if(_nuggN) params[@"nuggn"] = _nuggN;
    if(campaign_id) params[@"campid"] = campaign_id;
    if(format_id) params[@"ad_format_id"] = format_id;
    if(permission) params[@"tok"] = [adid UUIDString];
    
    [self nuggadCall:[_nuggDomain stringByAppendingString:@"/ci"]
          withParams:params
      withPermission:permission
            callType:NUGG_AD_SERVICE_CALL_CI];
}

-(void)nuggadUT:(NSString *)dpid andProductsList:(NSArray *)productslist andPermission:(Boolean)permission andAdID:(NSUUID*)adid{
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    if(dpid) params[@"dpid"] = dpid;
    if(permission) params[@"tok"] = [adid UUIDString];
    
    for (NuggAdUTProduct* product in productslist) {
        NSString* val = product.aida_value != -1 ? [NSString stringWithFormat:@"%i",product.aida_value] : @"";
        if (!isnan(product.ttl)) {
            val = [val stringByAppendingFormat:@",%.0f",product.ttl];
        }
        NSString* name = [product.data_name stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        NSString* key = [NSString stringWithFormat:@"products[%@]", name];
        params[key] = val;
    }
    
    [self nuggadCall:[_nuggDomain stringByAppendingString:@"/ut"]
          withParams:params
      withPermission:permission
            callType:NUGG_AD_SERVICE_CALL_UT];
}

-(void)nuggadFC:(Boolean)completed andPermission:(Boolean)permission andAdID:(NSUUID*)adid{
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    if(permission) params[@"counter"] = [NSNumber numberWithInt:(completed ? 99 : 1)];
    if(permission) params[@"tok"] = [adid UUIDString];
    
    [self nuggadCall:[_nuggDomain stringByAppendingString:@"/fc"]
          withParams:params
      withPermission:permission
            callType:NUGG_AD_SERVICE_CALL_FC];
}

#pragma mark - PRIVATE
+ (NSString*)encodeURL:(NSString *)string
{
    NSString *newString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, ( CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    
    if (newString)
    {
        return newString;
    }
    
    return @"";
}

NSString* machineName(){
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

@end
