//
//  SCResource.h
//  Melo
//
//  Created by Simon CORSIN on 20/07/14.
//  Copyright (c) 2014 Simon Corsin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCDynamicReference.h"

@interface SCResource : NSObject

@property (readonly, nonatomic) SCDynamicReference *reference;
@property (readonly, nonatomic) NSString *ID;

- (id)initWithID:(NSString *)ID value:(id)value;

@end
