//
//  FMSFetchDribbbleData.h
//  DribbbleClient
//
//  Created by Frank McAuley on 7/5/13.
//  Copyright (c) 2013 Frank McAuley. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FMSFetchDribbbleData <NSObject>

-(void)refreshContextData;

@end

@interface FMSFetchDribbbleData : NSObject

@property (nonatomic, assign) id <FMSFetchDribbbleData> delegate;

- (void)fetchDribbbleData;

@end
