//
//  SCImageResourcesHandler.m
//  Melo
//
//  Created by Simon CORSIN on 21/07/14.
//  Copyright (c) 2014 Simon Corsin. All rights reserved.
//

#import "SCImageResourcesHandler.h"

@implementation SCImageResourcesHandler

- (id)init {
    self = [super init];
    
    if (self) {
        _downloadCompleteAnimationEnabled = YES;
        _downloadCompleteAnimationDuration = kSCImageResourcesHandlerDefaultAnimationDuration;
        _downloadCompleteAnimationOptions = kSCImageResourcesHandlerDefaultAnimationOptions;
    }
    
    return self;
}

- (id)loadResource:(NSData *)data error:(NSError *__autoreleasing *)error {
    return [UIImage imageWithData:data];
}

- (void)installResource:(id)resource inReceiver:(id)receiver wasDownloaded:(BOOL)wasDownloaded {
    UIImageView *imageView = receiver;
    
    if (wasDownloaded && _downloadCompleteAnimationEnabled) {
        [UIView transitionWithView:imageView duration:_downloadCompleteAnimationDuration options:_downloadCompleteAnimationOptions animations:^{
            imageView.image = resource;
        } completion:nil];
    } else {
        imageView.image = resource;
    }
}

- (void)uninstallResourceFromReceiver:(id)receiver {
    UIImageView *imageView = receiver;
    imageView.image = nil;
}

- (BOOL)canHandleReceiver:(id)receiver {
    return [receiver isKindOfClass:[UIImageView class]];
}

@end
