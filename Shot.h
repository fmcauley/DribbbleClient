//
//  Shot.h
//  DribbbleClient
//
//  Created by Frank McAuley on 7/5/13.
//  Copyright (c) 2013 Frank McAuley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Shot : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSNumber * likeCount;
@property (nonatomic, retain) NSNumber * commentsCount;
@property (nonatomic, retain) NSNumber * reboundsCount;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * shortUrl;
@property (nonatomic, retain) NSNumber * viewCount;
@property (nonatomic, retain) NSString * reboundSourceId;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * imageTeaseUrl;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSManagedObject *player;

@end
