//
//  FMSDribbbleCollectionViewViewController.m
//  DribbbleClient
//
//  Created by Frank McAuley on 7/5/13.
//  Copyright (c) 2013 Frank McAuley. All rights reserved.
//

#define kDribbbleBGQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kDribbbleURLEveryoneURL [NSURL URLWithString:@"http://api.dribbble.com/shots/everyone"]


#import "FMSDribbbleCollectionViewViewController.h"

@interface FMSDribbbleCollectionViewViewController ()
- (void)loadDataFromDribbble;
- (void)fetchedData:(NSData *)responseData;

@end

@implementation FMSDribbbleCollectionViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self loadDataFromDribbble];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadDataFromDribbble
{
    dispatch_async(kDribbbleBGQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        kDribbbleURLEveryoneURL];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedData:(NSData *)responseData
{
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    NSArray* latestLoans = [json objectForKey:@"shots"];
    
    
    NSLog(@"shots: %@",latestLoans);
}

@end
