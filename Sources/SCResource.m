//
//  SCResource.m
//  Melo
//
//  Created by Simon CORSIN on 20/07/14.
//  Copyright (c) 2014 Simon Corsin. All rights reserved.
//

#import "SCResource.h"

@implementation SCResource

- (id)initWithID:(NSString *)ID value:(id)value {
    self = [self init];
    
    if (self) {
        _ID = ID;
        _reference = [[SCDynamicReference alloc] init];
        _reference.strong = YES;
        _reference.value = value;
    }
    
    return self;
}

@end
