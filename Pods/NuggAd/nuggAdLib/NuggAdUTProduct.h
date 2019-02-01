//
//  NuggAdUTProduct.h
//  nuggAdLib
//
//  Created by Benjamin Müller on 25.04.14.
//  Copyright (c) 2014 urbn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NuggAdUTProduct : NSObject

/**
 *  maximum 12 characters
 */
@property (copy, nonatomic) NSString* data_name;

/**
 *  stage of the sales funnel (1-9)
 */
@property (nonatomic) int aida_value;

/**
 *  time to live, (> 0)
 */
@property (nonatomic) NSTimeInterval ttl;


/**
 *  initialize NuggAdUTProduct easily. ttl will not be set.
 *
 *  @param name       data name
 *  @param aida       aida
 *
 *  @return instance
 */
-(id)initWithName:(NSString*)name AIDA:(int)aida;

/**
 *  initialize NuggAdUTProduct easily
 *
 *  @param name       data name
 *  @param aida       aida
 *  @param timetolive ttl, set to NAN to hide from call
 *
 *  @return instance
 */
-(id)initWithName:(NSString*)name AIDA:(int)aida andTTL:(NSTimeInterval)timetolive;

@end
