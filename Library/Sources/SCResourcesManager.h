//
//  SCAssetsManager.h
//  Melo
//
//  Created by Simon CORSIN on 20/07/14.
//  Copyright (c) 2014 Simon Corsin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCDynamicReference.h"
#import "SCResourcesCache.h"
#import "SCResourcesHandler.h"
#import "SCResourcesDownloadPolicy.h"
#import "SCResourcesManagerHolder.h"
#import "NSObject+Resources.h"
#import "SCImageResourcesHandler.h"

#define kSCResourcesManagerCacheFilename @"SCResourcesManagerCache.json"

@interface SCResourcesManager : NSObject

@property (strong, nonatomic) id<SCResourcesDownloadPolicy> downloadPolicy;

@property (readonly, nonatomic) NSArray *resourcesHandlers;

@property (assign, nonatomic) NSUInteger maxConcurrentDownloads;

@property (assign, nonatomic) BOOL diskCacheEnabled;

// Install a resource to a receiver.
// If the resource is not already downloaded, it will be enqueued for download.
// Once the download is completed, the resource will be installed to the receiver.
// The ResourcesManager will keep a weak reference on the receiver if a download is
// needed.
// Return YES if the resource was directly installed, NO if a download is needed
- (BOOL)installResourceUrl:(NSString *)resourceUrl toReceiver:(id)receiver;

// Uninstall any installed resource from a receiver
// If a download is pending, cancelDownload set to YES will cancel it
- (void)uninstallResourceFromReceiver:(id)receiver discardDownload:(BOOL)discardDownload;

- (void)addResourcesHandler:(id<SCResourcesHandler>)resourcesHandler;

- (void)removeResourcesHandler:(id<SCResourcesHandler>)resourcesHandler;

- (void)removeAllResourcesHandlers;

- (id<SCResourcesHandler>)resourceHandlerCompatibleWithReceiver:(id)receiver;

- (NSString *)localCachedUrlForResourceUrl:(NSString *)resourceUrl;

// The shared instance if fetched using the UIApplication delegate. This must implement the protocol
// "SCResourcesManagerHolder" in order to make this sharedInstance work.
+ (SCResourcesManager *)sharedInstance;

@end
