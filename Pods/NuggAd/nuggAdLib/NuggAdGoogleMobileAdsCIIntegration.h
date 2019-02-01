//
//  NuggAdGoogleMobileAdsCIIntegration.h
//  nuggAdLib
//
//  Created by Benjamin Müller on 17.06.14.
//  Copyright (c) 2014 urbn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NuggAdPrediction.h"
#import <UIKit/UIKit.h>

@class GADBannerView;

/**
 *  If you are part of one of the google ad networks like DoubleClick, you can use this helper class to extract the CI pixel from the ad view.
 */
@interface NuggAdGoogleMobileAdsCIIntegration : NSObject

/**
 *  Singleton initializer. This class is save to use with multiple instance.
 *
 *  @return an instance of NuggAdGoogleMobileAdsCIIntegration
 */
+(NuggAdGoogleMobileAdsCIIntegration*)sharedCIIntegration;


/**
 *  This method extracts the campid and ad_format_id from the ad displayed in the GADBannerView and calls nuggadCI:andFormat: of your nuggad prediction object.
 *
 *  call this method inside of your GADBannerViewDelegate's method adViewDidReceiveAd:
 *
 *    -(void)adViewDidReceiveAd:(GADBannerView *)view{
 *      [[NuggAdGoogleMobileAdsCIIntegration sharedCIIntegration] 
          extractCIFromAdView:view 
          andCallNuggad:my_nuggad_prediction_object];
 *    }
 *  @param bannerView    GADBannerView instance
 *  @param predictionObj shared nuggad prediction
 */
-(void)extractCIFromAdView:(GADBannerView*)bannerView andCallNuggad:(NuggAdPrediction*)predictionObj;

@end
