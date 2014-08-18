//
//  SCResourceCache.h
//  Melo
//
//  Created by Simon CORSIN on 20/07/14.
//  Copyright (c) 2014 Simon Corsin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCResourcesCache : NSObject

@property (assign, nonatomic) NSUInteger maxRetainedResources;

- (id)resourceForId:(NSString *)resourceId updateReferences:(BOOL)updateReferences;

- (void)setResource:(id)resource forId:(NSString *)resourceId;

@end
