//
//  NuggAdNotification.h
//  nuggAdLib
//
//  Created by Benjamin Müller on 18.03.13.
//  Copyright (c) 2013 urbn. All rights reserved.
//

/*!
 @header NuggAdNotification
 @abstract This is a little UI helper to display a localized disclaimer using the default Cocoa UIAlertView. You may use this for convenience or implement / subclass if you like. See the high level documentation for detailed requirements.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*!
@class NuggAdNotification
*/
@interface NuggAdNotification : NSObject

/*!
    Use this method to display an UIAlertView with a localized disclaimer.
 */
+(void)presentNuggadDisclaimer;

@end
