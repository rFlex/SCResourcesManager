//
//  SCResourceDownloadTask.h
//  Melo
//
//  Created by Simon CORSIN on 21/07/14.
//  Copyright (c) 2014 Simon Corsin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCResourcesHandler.h"
#import "SCDynamicReference.h"

@interface SCResourceDownloadTask : NSObject

@property (readonly, nonatomic) NSArray *pendingReceivers;

@property (readonly, nonatomic) NSString *url;

@property (strong, nonatomic) id<SCResourcesHandler> resourcesHandler;

- (id)initWithUrl:(NSString *)url;

- (void)addPendingReceiver:(id)receiver;

- (void)removePendingReceiver:(id)receiver;

@end
