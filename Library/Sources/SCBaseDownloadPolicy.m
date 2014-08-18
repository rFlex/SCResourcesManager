//
//  SCBaseDownloadPolicy.m
//  Melo
//
//  Created by Simon CORSIN on 21/07/14.
//  Copyright (c) 2014 Simon Corsin. All rights reserved.
//

#import "SCBaseDownloadPolicy.h"

@implementation SCBaseDownloadPolicy

- (SCResourceDownloadTask *)nextDownloadTaskFromPendingDownloadTasks:(NSArray *)pendingDownloadTask {
    SCResourceDownloadTask *bestCandidate = nil;
    
    for (SCResourceDownloadTask *downloadTask in pendingDownloadTask) {
        if (bestCandidate == nil || downloadTask.pendingReceivers.count > bestCandidate.pendingReceivers.count) {
            bestCandidate = downloadTask;
        }
    }
    
    return bestCandidate;
}

@end
