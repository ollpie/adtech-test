//
//  NuggAdPermission.h
//  nuggAdLib
//
//  Created by Benjamin Müller on 09.09.12.
//  Copyright (c) 2012 urbn. All rights reserved.
//

/*!
 @header NuggAdPermission
 @internal
*/

#import <UIKit/UIKit.h>


@interface NuggAdPermission : NSObject

// init
+ (NuggAdPermission*)sharedPermissions;

// read interface
- (Boolean)readGlobalPermission;
- (NSUUID*)adID;
- (Boolean)checkFirstCall;

@end