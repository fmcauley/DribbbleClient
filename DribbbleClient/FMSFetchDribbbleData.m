//
//  FMSFetchDribbbleData.m
//  DribbbleClient
//
//  Created by Frank McAuley on 7/5/13.
//  Copyright (c) 2013 Frank McAuley. All rights reserved.
//

#define kDribbbleBGQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kDribbbleURLEveryoneURL [NSURL URLWithString:@"http://api.dribbble.com/shots/everyone"]

#import "FMSFetchDribbbleData.h"

@interface FMSFetchDribbbleData ()

- (void)fetchInitalDataFromDribbble;
- (void)parseDribbbleData:(NSData *)responseData;

@end

@implementation FMSFetchDribbbleData

+ (void)fetchDribbbleData
{
    FMSFetchDribbbleData *local = [[self alloc]init];
    [local fetchInitalDataFromDribbble];
    
}

- (void)fetchInitalDataFromDribbble
{
    dispatch_async(kDribbbleBGQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        kDribbbleURLEveryoneURL];
        [self performSelectorOnMainThread:@selector(parseDribbbleData:)
                               withObject:data waitUntilDone:YES];
    });
}

- (void)parseDribbbleData:(NSData *)responseData
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    NSArray* latestLoans = [json objectForKey:@"shots"];
    
    
    NSLog(@"shots: %@",latestLoans);
}

@end
