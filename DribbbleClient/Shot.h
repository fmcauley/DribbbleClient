//
//  Shot.h
//  DribbbleClient
//
//  Created by Frank McAuley on 7/5/13.
//  Copyright (c) 2013 Frank McAuley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Player;

@interface Shot : NSManagedObject

@property (nonatomic, retain) NSNumber * commentsCount;
@property (nonatomic, retain) NSString * createdAt;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSString * shotId;
@property (nonatomic, retain) NSString * imageTeaseUrl;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSNumber * likeCount;
@property (nonatomic, retain) NSNumber * reboundsCount;
@property (nonatomic, retain) NSNumber * reboundSourceId;
@property (nonatomic, retain) NSString * shortUrl;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * viewCount;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) Player *player;

@end
