//
//  URBNSurveyViewController.m
//  DataDays
//
//  Created by Benjamin Müller on 18.03.13.
//  Copyright (c) 2013 urbn. All rights reserved.
//

#import "NuggAdSurveyViewController.h"

#define NUGGAD_SURVEY_SEND_URL "survey.nuggad.net/mobile-survey/send"
#define NUGGAD_SURVEY_CANCEL_URL "survey.nuggad.net/mobile-survey/cancel"

#define NUGGAD_YES_ENDPOINT "eu-cp.nuggad.net"

static Boolean __didUserCancel = false;

@implementation NuggAdSurveyViewController{
    UIWebView *_webview;
    
    void (^_completionBlock)(BOOL submit);
}

#pragma mark - SINGLETON CREATION
+(NuggAdSurveyViewController *)presentSurveyWithURL:(NSURL *)url
                                       onCompletion:(void (^)(BOOL))completion{
    
    CGRect fr = [UIApplication sharedApplication].delegate.window.rootViewController.view.bounds;
    
    
    NuggAdSurveyViewController* surveyCtrl = [[NuggAdSurveyViewController alloc]
                                              initWithFrame:fr
                                              andCompletionBlock:completion];
    surveyCtrl.surveyURL = url;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"nuggad_surveyAlert_title",
                                                                                                          @"NuggadLocalization",
                                                                                                          @"survey title")
                                                                       message:NSLocalizedStringFromTable(@"nuggad_surveyAlert_body",
                                                                                                          @"NuggadLocalization",
                                                                                                          @"survey alert body")
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* no = [UIAlertAction
                             actionWithTitle:NSLocalizedStringFromTable(@"nuggad_surveyAlert_no",
                                                                        @"NuggadLocalization",
                                                                        @"survey alert yes")
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action){
                                 
                                 [alert.presentingViewController dismissViewControllerAnimated:YES
                                                                                    completion:nil];
                                 __didUserCancel = true;
                                 completion(NO);   // inform listener - did not submit form
                             }];
        [alert addAction:no];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:NSLocalizedStringFromTable(@"nuggad_surveyAlert_yes",
                                                                        @"NuggadLocalization",
                                                                        @"survey alert no")
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action){
                                 
                                 [alert.presentingViewController dismissViewControllerAnimated:YES
                                                                                    completion:nil];
                                 [surveyCtrl setup];
                                 
                                 [[[[UIApplication sharedApplication] delegate] window].rootViewController presentModalViewController:surveyCtrl animated:YES];
                             }];
        [alert addAction:ok];
        
        [[[UIApplication sharedApplication].delegate window].rootViewController presentModalViewController:alert animated:YES];
        
    }else
    
#endif
    {

        UIAlertView* surveyAlert = [[UIAlertView alloc]
                                    initWithTitle:NSLocalizedStringFromTable(@"nuggad_surveyAlert_title",
                                                                                                 @"NuggadLocalization",
                                                                                                 @"survey title")
                                    message:NSLocalizedStringFromTable(@"nuggad_surveyAlert_body",
                                                                                     @"NuggadLocalization",
                                                                                     @"survey alert body")
                                    delegate:surveyCtrl
                                    cancelButtonTitle:NSLocalizedStringFromTable(@"nuggad_surveyAlert_no",
                                                                                     @"NuggadLocalization",
                                                                                     @"survey alert yes")
                                    otherButtonTitles:NSLocalizedStringFromTable(@"nuggad_surveyAlert_yes",
                                                                                     @"NuggadLocalization",
                                                                                     @"survey alert no"),nil];
        [surveyAlert show];
    }
    return surveyCtrl;
}

+(Boolean)didUserCancelLastCall{
    return __didUserCancel;
}

#pragma mark - INIT
-(id)initWithFrame:(CGRect)frame andCompletionBlock:(void (^)(BOOL))completion{
    if ((self = [super init])) {
        
        _completionBlock = completion;
        
        self.view.frame = frame;
    }
    
    return self;
}

-(void)setup{
    
    _webview = [[UIWebView alloc] initWithFrame:self.view.frame];
    _webview.scalesPageToFit = TRUE;
    _webview.scrollView.bounces = NO;
    _webview.delegate = self;
 
    [self.view addSubview:_webview];
    
    NSURLRequest* req = [NSURLRequest requestWithURL:_surveyURL
                                         cachePolicy:NSURLRequestReloadIgnoringCacheData
                                     timeoutInterval:2.0];
    
    if (_surveyURL)
        [_webview loadRequest:req];
}

// iOS5 rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

// iOS6+ rotation
- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - PROPERTIES
-(void)setSurveyURL:(NSURL *)surveyURL{
    _surveyURL = [surveyURL copy];
    
    [_webview loadRequest:[NSURLRequest requestWithURL:_surveyURL]];
}

#pragma mark - CLOSE HANDLER
- (void)close {

    __didUserCancel = false;
    _completionBlock(YES);  // inform listener - did submit form
    
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
    _webview = nil;
}

#pragma mark - ALERT DELEGATE
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex != 1){
        __didUserCancel = true;
        _completionBlock(NO);   // inform listener - did not submit form
        return;
    }
    
    [self setup];
    
    [[[[UIApplication sharedApplication] delegate] window].rootViewController presentModalViewController:self animated:YES];
}

#pragma mark - WEBVIEW HANDLER

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if ([request.URL.relativePath isEqualToString:@"/mobile-survey/cancel"] ||
        [request.URL.relativePath isEqualToString:@"/mobile-survey/cancel/"] ) {
        
        [self close];
        
        return false;
    }

    return true;
}

@end
