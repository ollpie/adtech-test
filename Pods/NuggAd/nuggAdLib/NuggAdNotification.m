//
//  NuggAdNotification.m
//  nuggAdLib
//
//  Created by Benjamin Müller on 18.03.13.
//  Copyright (c) 2013 urbn. All rights reserved.
//

#import "NuggAdNotification.h"

@implementation NuggAdNotification

+(void)presentNuggadDisclaimer{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"nuggad_disclaimer_title",
                                                                                                          @"NuggadLocalization",
                                                                                                          @"disclaimer title")
                                                                                                          message:NSLocalizedStringFromTable(@"nuggad_disclaimer_ios7plus_body",
                                                                                                                                             @"NuggadLocalization",
                                                                                                                                             @"disclaimer title")
                                                                                                   preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action){

                                 [alert.presentingViewController dismissViewControllerAnimated:YES
                                                                                    completion:nil];
                             }];
        [alert addAction:ok];
        
        [[[UIApplication sharedApplication].delegate window].rootViewController presentModalViewController:alert animated:YES];
    }else
        
#endif
        
    {
    
        UIAlertView* alert;
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            
            alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"nuggad_disclaimer_title",
                                                                                  @"NuggadLocalization",
                                                                                  @"disclaimer title")
                                               message:NSLocalizedStringFromTable(@"nuggad_disclaimer_ios7plus_body",
                                                                                  @"NuggadLocalization",
                                                                                  @"disclaimer title")
                                              delegate:self
                                     cancelButtonTitle:NSLocalizedStringFromTable(@"nuggad_disclaimer_agree",
                                                                                  @"NuggadLocalization",
                                                                                  @"disclaimer title")
                                     otherButtonTitles:nil];
            
        }else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
            
            
            alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"nuggad_disclaimer_title",
                                                                                  @"NuggadLocalization",
                                                                                  @"disclaimer title")
                                               message:NSLocalizedStringFromTable(@"nuggad_disclaimer_ios6plus_body",
                                                                                  @"NuggadLocalization",
                                                                                  @"disclaimer title")
                                              delegate:self
                                     cancelButtonTitle:NSLocalizedStringFromTable(@"nuggad_disclaimer_agree",
                                                                                  @"NuggadLocalization",
                                                                                  @"disclaimer title")
                                     otherButtonTitles:nil];
        }else{
            alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"nuggad_disclaimer_title",
                                                                                  @"NuggadLocalization",
                                                                                  @"disclaimer title")
                                               message:NSLocalizedStringFromTable(@"nuggad_disclaimer_ios5_body",
                                                                                  @"NuggadLocalization",
                                                                                  @"disclaimer title")
                                              delegate:self
                                     cancelButtonTitle:NSLocalizedStringFromTable(@"nuggad_disclaimer_agree",
                                                                                  @"NuggadLocalization",
                                                                                  @"disclaimer title")
                                     otherButtonTitles:nil];
        }
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        
        UILabel *body = [alert valueForKey:@"_bodyTextLabel"];
        
        [body setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        
#endif
        
        [alert show];
    }
}

@end
