//
//  SCVideoResourcesHandler.m
//  Melo
//
//  Created by Simon CORSIN on 25/07/14.
//  Copyright (c) 2014 Simon Corsin. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "SCVideoResourcesHandler.h"

@implementation SCVideoResourcesHandler

- (id)loadResource:(NSData *)data error:(NSError **)error {
    return nil;
}

- (void)installResource:(id)resource inReceiver:(id)receiver wasDownloaded:(BOOL)wasDownloaded {
    
}

- (void)uninstallResourceFromReceiver:(id)receiver {
    
}

- (BOOL)canHandleReceiver:(id)receiver {
    return NO;
}

@end
