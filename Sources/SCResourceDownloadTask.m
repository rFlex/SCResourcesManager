//
//  SCResourceDownloadTask.m
//  Melo
//
//  Created by Simon CORSIN on 21/07/14.
//  Copyright (c) 2014 Simon Corsin. All rights reserved.
//

#import "SCResourceDownloadTask.h"

@interface SCResourceDownloadTask() {
    NSMutableArray *_pendingReceivers;
}

@end

@implementation SCResourceDownloadTask

- (id)initWithUrl:(NSString *)url {
    self = [self init];
    
    if (self) {
        _url = url;
        _pendingReceivers = [NSMutableArray new];
    }
    
    return self;
}

- (void)addPendingReceiver:(id)receiver {
    [_pendingReceivers addObject:[SCDynamicReference dynamicReferenceWithValue:receiver strong:NO]];
}

- (void)removePendingReceiver:(id)receiver {
    for (int i = 0; i < _pendingReceivers.count; i++) {
        SCDynamicReference *dynReference = [_pendingReceivers objectAtIndex:i];
        
        if (dynReference.value == receiver) {
            [_pendingReceivers removeObjectAtIndex:i];
            i--;
        }
    }
}

- (NSArray *)pendingReceivers {
    return _pendingReceivers;
}

@end
