//
//  SCResourcesDownloadPolicy.h
//  Melo
//
//  Created by Simon CORSIN on 21/07/14.
//  Copyright (c) 2014 Simon Corsin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCResourceDownloadTask.h"

@protocol SCResourcesDownloadPolicy <NSObject>

- (SCResourceDownloadTask *)nextDownloadTaskFromPendingDownloadTasks:(NSArray *)pendingDownloadTask;

@end
