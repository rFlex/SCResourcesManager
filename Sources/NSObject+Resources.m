//
//  NSObject+Resources.m
//  Melo
//
//  Created by Simon CORSIN on 21/07/14.
//  Copyright (c) 2014 Simon Corsin. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+Resources.h"
#import "SCResourcesManager.h"

#define kResourceUrlKey "ResourceUrl"

@implementation NSObject (Resources)

- (void)setResourceUrl:(NSString *)resourceUrl {
    NSString *oldResourceUrl = self.resourceUrl;
    
    if (oldResourceUrl != resourceUrl) {
        SCResourcesManager *resourcesManager = [SCResourcesManager sharedInstance];
        
        if (oldResourceUrl != nil) {
            [resourcesManager uninstallResourceFromReceiver:self discardDownload:NO];
        }
        
        objc_setAssociatedObject(self, kResourceUrlKey, resourceUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        if (resourceUrl != nil) {
            [resourcesManager installResourceUrl:resourceUrl toReceiver:self];
        }
    }
}

- (NSString *)resourceUrl {
    return objc_getAssociatedObject(self, kResourceUrlKey);
}

@end
