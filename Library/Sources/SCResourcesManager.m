//
//  SCAssetsManager.m
//  Melo
//
//  Created by Simon CORSIN on 20/07/14.
//  Copyright (c) 2014 Simon Corsin. All rights reserved.
//

#import "SCResourcesManager.h"
#import "SCResourcesCache.h"
#import "SCResourceDownloadTask.h"
#import "SCBaseDownloadPolicy.h"

@interface SCResourcesManager() {
    NSMutableArray *_resourcesHandlers;
    SCResourcesCache *_cache;
    NSMutableArray *_pendingDownloadTasks;
    NSMutableArray *_currentDownloadTasks;
    NSMutableDictionary *_downloadTasksByReceiver;
    NSMutableDictionary *_downloadTasksByUrl;
    NSOperationQueue *_operationQueue;
}

@end

@implementation SCResourcesManager

- (id)init {
    self = [super init];
    
    if (self) {
        _resourcesHandlers = [NSMutableArray new];
        _cache = [[SCResourcesCache alloc] init];
        _pendingDownloadTasks = [NSMutableArray new];
        _currentDownloadTasks = [NSMutableArray new];
        _downloadTasksByReceiver = [NSMutableDictionary new];
        _downloadTasksByUrl = [NSMutableDictionary new];
        _operationQueue = [NSOperationQueue new];
        _operationQueue.maxConcurrentOperationCount = 3;
        _diskCacheEnabled = NO;
        
        self.downloadPolicy = [[SCBaseDownloadPolicy alloc] init];
        
        [self addResourcesHandler:[[SCImageResourcesHandler alloc] init]];
    }
    
    return self;
}

#pragma mark -- Cache

- (NSString *)localCachedUrlForResourceUrl:(NSString *)url {
    return url;
}

- (void)cacheResource:(id)resource forUrl:(NSString *)url {
    [_cache setResource:resource forId:url];
}

- (void)cacheData:(NSData *)data toUrl:(NSString *)url {
    if (_diskCacheEnabled) {
        NSString *cachedUrl = [self localCachedUrlForResourceUrl:url];
        
        [data writeToFile:cachedUrl atomically:YES];
    }
}

- (BOOL)cachedDataExistsFromUrl:(NSString *)resourceUrl {
    BOOL fileExists = NO;
    
    if (_diskCacheEnabled) {
        
    }
    
    return fileExists;
}

- (NSData *)loadCachedDataFromUrl:(NSString *)resourceUrl {
    NSData *cachedData = nil;
    
    if (_diskCacheEnabled) {
        
    }
    
    return cachedData;
}

#pragma mark -- Install/Uninstall

- (BOOL)installResourceUrl:(NSString *)resourceUrl toReceiver:(id)receiver {
    [self uninstallResourceFromReceiver:receiver discardDownload:NO];
    
    id<SCResourcesHandler> resourceHandler = [self resourceHandlerCompatibleWithReceiver:receiver];
    
    id resource = [_cache resourceForId:resourceUrl updateReferences:YES];
    
    if (resource == nil) {
        SCResourceDownloadTask *downloadTask = [_downloadTasksByUrl objectForKey:resourceUrl];
        BOOL shouldAddOperation = NO;
        
        if (downloadTask == nil) {
            if ([self cachedDataExistsFromUrl:resourceUrl]) {
                if (resourceHandler != nil) {
                    NSData *cachedData = [self loadCachedDataFromUrl:resourceUrl];
                    resource = [resourceHandler loadResource:cachedData error:nil];
                    if (resource != nil) {
                        [self cacheResource:resource forUrl:resourceUrl];
                    }
                }
            } else {
                downloadTask = [[SCResourceDownloadTask alloc] initWithUrl:resourceUrl];
                [_downloadTasksByUrl setObject:downloadTask forKey:resourceUrl];
                [_pendingDownloadTasks addObject:downloadTask];
                shouldAddOperation = YES;
            }
        }
        
        if (downloadTask != nil && receiver != nil) {
            [downloadTask addPendingReceiver:receiver];
            [_downloadTasksByReceiver setObject:downloadTask forKey:[NSValue valueWithNonretainedObject:receiver]];
            
            if (resourceHandler != nil) {
                downloadTask.resourcesHandler = resourceHandler;
                if ([resourceHandler respondsToSelector:@selector(prepareReceiverForDownloading:)]) {
                    [resourceHandler prepareReceiverForDownloading:receiver];
                }
            }
        }
        
        if (shouldAddOperation) {
            [_operationQueue addOperation:[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(handleNextDownload) object:nil]];
        }
    }
    
    if (resource != nil) {
        [resourceHandler installResource:resource inReceiver:receiver wasDownloaded:NO];
        return YES;
    }
    
    return NO;
}

- (void)uninstallResourceFromReceiver:(id)receiver discardDownload:(BOOL)discardDownload {
    NSValue *key = [NSValue valueWithNonretainedObject:receiver];

    SCResourceDownloadTask *downloadTask = [_downloadTasksByReceiver objectForKey:key];
    
    if (downloadTask != nil) {
        [_downloadTasksByReceiver removeObjectForKey:key];
        [downloadTask removePendingReceiver:receiver];
        
        if (discardDownload && downloadTask.pendingReceivers.count == 0) {
            [_downloadTasksByUrl removeObjectForKey:downloadTask.url];
        }
    } else {
        id<SCResourcesHandler> resourceHandler = [self resourceHandlerCompatibleWithReceiver:receiver];

        [resourceHandler uninstallResourceFromReceiver:receiver];
    }
}

#pragma mark -- ResourcesHandlers

- (void)addResourcesHandler:(id<SCResourcesHandler>)resourcesHandler {
    [_resourcesHandlers addObject:resourcesHandler];
}

- (void)removeResourcesHandler:(id<SCResourcesHandler>)resourcesHandler {
    [_resourcesHandlers removeObject:resourcesHandler];
}

- (void)removeAllResourcesHandlers {
    [_resourcesHandlers removeAllObjects];
}

- (id<SCResourcesHandler>)resourceHandlerCompatibleWithReceiver:(id)receiver {
    if (receiver == nil) {
        return nil;
    }
    
    for (id<SCResourcesHandler> resourceHandler in _resourcesHandlers) {
        if ([resourceHandler canHandleReceiver:receiver]) {
            return resourceHandler;
        }
    }
    
    return nil;
}

#pragma mark -- Download LifeCycle

- (SCResourceDownloadTask *)nextDownloadTask {
    SCResourceDownloadTask *downloadTask = nil;
    
    if (_pendingDownloadTasks.count > 0) {
        downloadTask = [_downloadPolicy nextDownloadTaskFromPendingDownloadTasks:_pendingDownloadTasks];
        
        if (downloadTask != nil) {
            [_pendingDownloadTasks removeObject:downloadTask];
            [_currentDownloadTasks addObject:downloadTask];
        }
    }
    
    return downloadTask;
}

- (void)handleNextDownload {
    __block SCResourceDownloadTask *downloadTask = nil;
    __block id<SCResourcesHandler> resourceHandler = nil;

    dispatch_sync(dispatch_get_main_queue(), ^{
        downloadTask = [self nextDownloadTask];
        
        if (downloadTask != nil) {
            resourceHandler = downloadTask.resourcesHandler;
        }
    });
    
    if (downloadTask != nil) {
        NSString *url = downloadTask.url;
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url] options:NSDataReadingUncached error:&error];
        id resource = nil;
        
        if (error == nil) {
            [self cacheData:data toUrl:url];
            
            if (resourceHandler != nil) {
                resource = [resourceHandler loadResource:data error:&error];
            }
        }
        
        if (resource != nil) {
            // We can release the data right now if the resource has been sucessfully loaded
            data = nil;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self downloadTask:downloadTask completedWithError:error resource:resource data:data];
        });
    }
}

- (void)downloadTask:(SCResourceDownloadTask *)downloadTask completedWithError:(NSError *)error resource:(id)resource data:(NSData *)data {
    [_currentDownloadTasks removeObject:downloadTask];
    [_downloadTasksByUrl removeObjectForKey:downloadTask.url];
    id<SCResourcesHandler> resourcesHandler = downloadTask.resourcesHandler;
    
    for (SCDynamicReference *receiverRef in downloadTask.pendingReceivers) {
        [_downloadTasksByReceiver removeObjectForKey:[NSValue valueWithNonretainedObject:receiverRef.unretainedValue]];
        
        id receiver = receiverRef.value;
        
        if (receiver != nil) {
            if (error == nil && resource == nil && data != nil) {
                resource = [resourcesHandler loadResource:data error:&error];
                data = nil;
            }
            
            if (resource == nil) {
                if ([resourcesHandler respondsToSelector:@selector(resourceUrl:failedToInstall:inReceiver:)]) {
                    [resourcesHandler resourceUrl:downloadTask.url failedToInstall:error inReceiver:receiver];
                } else {
                    NSLog(@"Resource url %@ failed to download", downloadTask.url);
                }
            } else {
                [resourcesHandler installResource:resource inReceiver:receiver wasDownloaded:YES];
            }
        }
    }
    
    if (resource != nil) {
        [self cacheResource:resource forUrl:downloadTask.url];
    }
}

#pragma mark -- Properties

- (NSArray *)resourcesHandlers {
    return _resourcesHandlers;
}

- (NSArray *)pendingDownloadTasks {
    return _pendingDownloadTasks;
}

- (NSArray *)currentDownloadTasks {
    return _currentDownloadTasks;
}

- (NSUInteger)maxConcurrentDownloads {
    return _operationQueue.maxConcurrentOperationCount;
}

- (void)setMaxConcurrentDownloads:(NSUInteger)maxConcurrentDownloads {
    _operationQueue.maxConcurrentOperationCount = maxConcurrentDownloads;
}

static SCResourcesManager *_sharedInstance = nil;

+ (SCResourcesManager *)sharedInstance {
    if (_sharedInstance != nil) {
        return _sharedInstance;
    }
    
    static dispatch_once_t onceToken;
    
    id del = [UIApplication sharedApplication].delegate;
    SCResourcesManager *resourcesManager = nil;
    
    if ([del respondsToSelector:@selector(resourcesManager)]) {
        resourcesManager = [del resourcesManager];
    }
    
    if (resourcesManager == nil) {
        dispatch_once(&onceToken, ^{
            _sharedInstance = [[SCResourcesManager alloc] init];
        });

        return _sharedInstance;
    }
    
    return resourcesManager;
}

@end
