//
//  SCImageResourcesHandler.h
//  Melo
//
//  Created by Simon CORSIN on 21/07/14.
//  Copyright (c) 2014 Simon Corsin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCResourcesHandler.h"

#define kSCImageResourcesHandlerDefaultAnimationDuration 0.3
#define kSCImageResourcesHandlerDefaultAnimationOptions UIViewAnimationOptionTransitionCrossDissolve

@interface SCImageResourcesHandler : NSObject<SCResourcesHandler>

// Whether the SCImageResourcesHandler should animate the UIImageView when the download is completed
// Default is YES
@property (assign, nonatomic) BOOL downloadCompleteAnimationEnabled;

// The animation duration for when the download is completed, default is kSCImageResourcesHandlerDefaultAnimationDuration
@property (assign, nonatomic) CGFloat downloadCompleteAnimationDuration;

// The animation options for when the download is completed, default is kSCImageResourcesHandlerDefaultAnimationOptions
@property (assign, nonatomic) UIViewAnimationOptions downloadCompleteAnimationOptions;

@end
