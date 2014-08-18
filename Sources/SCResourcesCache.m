//
//  SCResourceCache.m
//  Melo
//
//  Created by Simon CORSIN on 20/07/14.
//  Copyright (c) 2014 Simon Corsin. All rights reserved.
//

#import "SCResourcesCache.h"
#import "SCResource.h"

@interface SCResourcesCache() {
    NSMutableDictionary *_resourcesById;
    NSMutableArray *_resources;
}

@end

@implementation SCResourcesCache

- (id)init {
    self = [super init];
    
    if (self) {
        _resourcesById = [NSMutableDictionary new];
        _resources = [NSMutableArray new];
    }
    
    return self;
}

- (void)_updateReferences {
    int count = (int)_resources.count;
    int maxRetainedResources = (int)self.maxRetainedResources;
    
    for (int i = 0; i < count; i++) {
        NSUInteger currentIdx = count - i - 1;
        SCResource *resource = [_resources objectAtIndex:currentIdx];
        resource.reference.strong = i <= maxRetainedResources;
        
        if (!resource.reference.isAlive) {
            [_resources removeObjectAtIndex:currentIdx];
            [_resourcesById removeObjectForKey:resource.ID];
            i--;
            count--;
        }
    }
}

- (id)resourceForId:(NSString *)resourceId updateReferences:(BOOL)updateReferences {
    SCResource *resource = [_resourcesById objectForKey:resourceId];
    id resourceValue = nil;
    
    if (resource != nil) {
        if (updateReferences) {
            [_resources removeObject:resource];
        }
        
        resourceValue = resource.reference.value;
        
        if (resourceValue == nil) {
            [_resourcesById removeObjectForKey:resourceId];
            if (!updateReferences) { // Object has been already removed if updateReferences is YES
                [_resources removeObject:resource];
            }
            
        } else {
            if (updateReferences) {
                [_resources addObject:resource];
                [self _updateReferences];
            }
        }
    }
    
    return resourceValue;
}

- (void)setResource:(id)resourceValue forId:(NSString *)resourceId {
    if (resourceValue == nil) {
        SCResource *resource = [_resourcesById objectForKey:resourceId];
        
        if (resource != nil) {
            [_resourcesById removeObjectForKey:resourceId];
            [_resources removeObject:resource];
        }
    } else {
        SCResource *resource = [_resourcesById objectForKey:resourceId];
        
        if (resource == nil) {
            resource = [[SCResource alloc] initWithID:resourceId value:resourceValue];
            [_resourcesById setObject:resource forKey:resourceId];
        } else {
            resource.reference.value = resourceValue;
            [_resources removeObject:resource];
        }
        
        [self _updateReferences];
        
    }
}

- (void)setMaxRetainedResources:(NSUInteger)maxRetainedResources {
    _maxRetainedResources = maxRetainedResources;
    
    [self _updateReferences];
}

@end
