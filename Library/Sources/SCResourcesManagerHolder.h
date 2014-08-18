//
//  SCResourcesManagerHolder.h
//  Melo
//
//  Created by Simon CORSIN on 21/07/14.
//  Copyright (c) 2014 Simon Corsin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCResourcesManager;

@protocol SCResourcesManagerHolder <NSObject>

- (SCResourcesManager *)resourcesManager;

@end
