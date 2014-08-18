//
//  SCDynamicReference.h
//  Melo
//
//  Created by Simon CORSIN on 20/07/14.
//  Copyright (c) 2014 Simon Corsin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCDynamicReference : NSObject

@property (assign, nonatomic) BOOL strong;

@property (assign, nonatomic) id value;

@property (readonly, nonatomic) BOOL isAlive;

// The last known value. May contains an invalid pointer
@property (readonly, nonatomic, unsafe_unretained) id unretainedValue;

- (id)initWithValue:(id)value strong:(BOOL)strong;

+ (SCDynamicReference *)dynamicReferenceWithValue:(id)value strong:(BOOL)strong;

@end
