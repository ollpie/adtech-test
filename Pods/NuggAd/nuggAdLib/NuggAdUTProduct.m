//
//  NuggAdUTProduct.m
//  nuggAdLib
//
//  Created by Benjamin Müller on 25.04.14.
//  Copyright (c) 2014 urbn. All rights reserved.
//

#import "NuggAdUTProduct.h"

@implementation NuggAdUTProduct

-(id)initWithName:(NSString *)name AIDA:(int)aida andTTL:(NSTimeInterval)timetolive{
    if (([super init])) {
        _ttl = NAN;
        _aida_value = -1;
        
        self.data_name = name;
        self.aida_value = aida;
        self.ttl = timetolive;
    }
    
    return self;
}

-(id)initWithName:(NSString *)name AIDA:(int)aida{
    if (([super init])) {
        self.data_name = name;
        self.aida_value = aida;
        self.ttl = NAN;
    }
    
    return self;
}

#pragma mark - PROPERTIES
-(void)setData_name:(NSString *)data_name{
    NSAssert1(data_name && data_name.length <= 12, @"supplied data_name: '%@' is longer than the allowed maximum of 12 characters", data_name);
    
    _data_name = [data_name copy];
}

-(void)setAida_value:(int)aida_value{
    NSAssert1(aida_value == -1 || (aida_value >= 1 && aida_value <= 9), @"supplied AIDA value: '%i' is out of allowed range.", aida_value);
    
    _aida_value = aida_value;
}

-(void)setTtl:(NSTimeInterval)ttl{
    NSAssert1(ttl > 0 || isnan(ttl), @"supplied ttl: '%f' is not greater than 0", ttl);
    
    _ttl = ttl;
}

@end
