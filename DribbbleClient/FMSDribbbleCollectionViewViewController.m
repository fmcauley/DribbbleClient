//
//  FMSDribbbleCollectionViewViewController.m
//  DribbbleClient
//
//  Created by Frank McAuley on 7/5/13.
//  Copyright (c) 2013 Frank McAuley. All rights reserved.
//

#import "FMSDribbbleCollectionViewViewController.h"
#import "FMSFetchDribbbleData.h"

@interface FMSDribbbleCollectionViewViewController ()
@end

@implementation FMSDribbbleCollectionViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[FMSFetchDribbbleData fetchDribbbleData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
