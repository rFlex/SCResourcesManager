//
//  SCResourcesHandler.h
//  Melo
//
//  Created by Simon CORSIN on 21/07/14.
//  Copyright (c) 2014 Simon Corsin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCResourcesHandler <NSObject>

- (id)loadResource:(NSData *)data error:(NSError **)error;

- (void)installResource:(id)resource inReceiver:(id)receiver wasDownloaded:(BOOL)wasDownloaded;

- (void)uninstallResourceFromReceiver:(id)receiver;

- (BOOL)canHandleReceiver:(id)receiver;

@optional

- (void)prepareReceiverForDownloading:(id)receiver;

- (void)resourceUrl:(NSString *)resourceUrl failedToInstall:(NSError *)error inReceiver:(id)receiver;

@end
