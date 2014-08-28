//
//  SCViewController.m
//  ResourcesManagerExample
//
//  Created by Simon CORSIN on 21/08/14.
//  Copyright (c) 2014 Simon Corsin. All rights reserved.
//

#import "SCViewController.h"
#import "SCResourcesManager.h"

@interface SCViewController ()

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.resourceUrl = @"http://sd.keepcalm-o-matic.co.uk/i/keep-calm-and-trololo--43.png";
    
    self.imageView.resourceUrl = @"http://sd.keepcalm-o-matic.co.uk/i/keep-calm-and-trololo--43.png";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
