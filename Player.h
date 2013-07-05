//
//  Player.h
//  DribbbleClient
//
//  Created by Frank McAuley on 7/5/13.
//  Copyright (c) 2013 Frank McAuley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Shot;

@interface Player : NSManagedObject

@property (nonatomic, retain) NSString * avatarUrl;
@property (nonatomic, retain) NSNumber * commentsCount;
@property (nonatomic, retain) NSNumber * commentsReceivedCount;
@property (nonatomic, retain) NSString * createdAt;
@property (nonatomic, retain) NSString * draftedByPlayerId;
@property (nonatomic, retain) NSNumber * drafteesCount;
@property (nonatomic, retain) NSNumber * followersCount;
@property (nonatomic, retain) NSNumber * followingCount;
@property (nonatomic, retain) NSString * playerId;
@property (nonatomic, retain) NSNumber * likesCount;
@property (nonatomic, retain) NSNumber * likesReceivedCount;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * reboundsCount;
@property (nonatomic, retain) NSNumber * reboundsReceivedCount;
@property (nonatomic, retain) NSNumber * shotsCount;
@property (nonatomic, retain) NSString * twitterScreenName;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * websiteUrl;
@property (nonatomic, retain) Shot *shot;

@end
