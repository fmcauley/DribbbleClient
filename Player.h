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

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * followersCount;
@property (nonatomic, retain) NSNumber * drafteesCount;
@property (nonatomic, retain) NSNumber * likesCount;
@property (nonatomic, retain) NSNumber * likesReceivedCount;
@property (nonatomic, retain) NSNumber * commentsCount;
@property (nonatomic, retain) NSNumber * commentsReceivedCount;
@property (nonatomic, retain) NSNumber * reboundsCount;
@property (nonatomic, retain) NSNumber * reboundsReceivedCount;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * avatarUrl;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * twitterScreenName;
@property (nonatomic, retain) NSString * websiteUrl;
@property (nonatomic, retain) NSString * draftedByPlayerId;
@property (nonatomic, retain) NSNumber * shotsCount;
@property (nonatomic, retain) NSNumber * followingCount;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) Shot *shot;

@end
