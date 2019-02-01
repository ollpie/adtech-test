//
//  URBNSurveyViewController.h
//  DataDays
//
//  Created by Benjamin Müller on 18.03.13.
//  Copyright (c) 2013 urbn. All rights reserved.
//

/*!
 @header NuggAdSurveyViewController
 @abstract This is a little UI helper to display an alert view which asks the user to fill out a survey. In case of agreement, a view controller containing a webview with the survey is pushed modally on top of your applications RootViewController. The user can close the survey at anytime by selecting a close button.
 */


#import <UIKit/UIKit.h>

/** 
 NuggAdSurveyViewController
 */
@interface NuggAdSurveyViewController : UIViewController <UIAlertViewDelegate,UIWebViewDelegate>

@property (copy, nonatomic) NSURL* surveyURL;

/**
 Call this method to present the survey alert.
 @param url Pass in the URL you'll get in [NuggAdPrediction nuggAd: showSurveyWithURL: ]
 */
+(NuggAdSurveyViewController*)presentSurveyWithURL:(NSURL*)url onCompletion:(void (^)(BOOL submit))completion;

/**
 Call this function ask if last call to presentSurveyWithURL: was cancelled by the user.
*/
+(Boolean)didUserCancelLastCall;

-(void)setup;

@end
