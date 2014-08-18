//
//  SCDynamicReference.m
//  Melo
//
//  Created by Simon CORSIN on 20/07/14.
//  Copyright (c) 2014 Simon Corsin. All rights reserved.
//

#import "SCDynamicReference.h"

@interface SCDynamicReference() {
    __weak id _weakValue;
    __strong id _strongValue;
}

@end

@implementation SCDynamicReference

- (id)initWithValue:(id)value strong:(BOOL)strong {
    self = [self init];
    
    if (self) {
        self.strong = strong;
        self.value = value;
    }
    
    return self;
}

- (void)setStrong:(BOOL)strong {
    if (_strong != strong) {
        id value = self.value;
        
        _weakValue = nil;
        _strongValue = nil;
        
        _strong = strong;
        
        self.value = value;
    }
}

- (void)setValue:(id)value {
    if (_strong) {
        _strongValue = value;
    } else {
        _weakValue = value;
    }
    _unretainedValue = value;
}

- (id)value {
    return _strong ? _strongValue : _weakValue;
}

- (BOOL)isAlive {
    return _strongValue != nil || _weakValue != nil;
}

+ (SCDynamicReference *)dynamicReferenceWithValue:(id)value strong:(BOOL)strong {
    return [[SCDynamicReference alloc] initWithValue:value strong:strong];
}

@end
